# Lambda Render

Distributed render on AWS Lambda via @remotion/lambda. Used for master renders and for parallel preview batches.

## Setup

1. Deploy the Remotion bundle to a serve URL:
   npx remotion lambda sites create src/index.ts --site-name=<project-slug>

2. Note the serve URL. It is passed to the render command.

3. Verify the Lambda function is deployed:
   npx remotion lambda functions deploy

## Render

npx remotion lambda render <serve-url> <composition-id> \
 --frames-per-lambda=20 \
 --memory=3009

## Memory

Default: 3009MB (3 vCPUs). This is the cost/speed sweet spot for motion design in Remotion.

Lower memory reduces cost but slows render. Higher memory is available up to 10240MB but rarely justified for this pipeline.

## Frames per Lambda

Default: 20. Range: 5-100.

Rules:

- Every chunk must render the same number of frames except the last.
- Uneven chunks cause AAC audio artifacts at concatenation.
- For compositions under 300 frames, use a single Lambda (frames-per-lambda = durationInFrames).
- For compositions over 1200 frames, cap at 50 to keep individual render times bounded.

## Concurrency

Default: 1000 concurrent Lambdas per region. Adjust with --concurrency if the AWS account has limits.

## Audio concatenation

Remotion 4.0.130+ supports audio concatenation without a full re-encode pass. This reduces render time significantly on longer videos.

Enable by keeping Remotion at 4.0.130 or later and using the standard render command. No flag required.

If using an older version, audio is re-encoded per chunk, which is slower and can introduce artifacts at chunk boundaries.

## Chunk boundaries and audio

Rule: every chunk renders the same number of frames, except the last. Uneven chunks cause the audio encoder to place silence or artifacts at the join.

Example for a 900-frame composition with frames-per-lambda=20:

- 44 chunks of 20 frames each
- 1 final chunk of 20 frames (because 45 \* 20 = 900)

Example for a 950-frame composition with frames-per-lambda=20:

- 47 chunks of 20 frames
- 1 final chunk of 10 frames

The final chunk is allowed to be smaller. Intermediate chunks are not.

## Serve URL

- The serve URL is a deployed bundle, not a local path.
- Redeploy the bundle after any source change.
- Serve URL is stable across renders until redeployed.

## Cleanup

- Lambda render outputs are stored in S3.
- Set a lifecycle policy on the S3 bucket to expire outputs after 30 days.
- Clean up old bundles periodically.

## Determinism

Lambda renders must match local renders frame for frame. Any difference indicates:

- Font loading race
- Different Remotion version between local and Lambda
- Different Chrome version between local and Lambda
- Unseeded random
- Network dependency

Fix the source, do not paper over the difference.

## Cost

- Cost is a function of frames, memory, and region.
- Track per-render cost in run.json under renderLog.
- Estimate master render cost at gate 8 and compare to the budget tier in brief.Q16.
- Over-budget renders require client sign-off.

## Failure modes

- "Function not found" — Lambda function not deployed; run `npx remotion lambda functions deploy`
- "Serve URL invalid" — bundle not deployed or expired; redeploy
- "Chunk timeout" — reduce frames-per-lambda or increase memory
- "Audio artifact at join" — check chunk sizes
- "S3 permission denied" — check IAM role for the Lambda function
- "Concurrency limit" — reduce --concurrency or request a limit increase

## Local vs Lambda decision

Use local render when:

- Scene is short (<= 300 frames)
- Single preview render
- Iterating on a scene
- No AWS access

Use Lambda when:

- Master render
- Multiple scenes in parallel
- Batch preview of the full set
- Long compositions (> 600 frames)
