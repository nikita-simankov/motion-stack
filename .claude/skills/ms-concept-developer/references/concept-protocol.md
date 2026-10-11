# Concept Protocol

## Expand

Triggered by /ms-concept-developer expand or by the client sending "more".

1. Re-read brief.json and dossier.json.
2. Identify structural families not yet used in the current set.
3. Generate one concept per unused family, up to the --count cap.
4. Score every new concept on the full rubric.
5. Append to concepts.json. Re-present the full table.

Do not replace existing concepts. Only append.

## Rescore

Triggered by /ms-concept-developer rescore or by a brief or dossier change.

1. Recompute scores for every concept, active and alternate.
2. If any concept drops below 60, mark it killed.
3. If the selected concept drops below 75, re-open the gate and re-present.
4. Update concepts.json with new scores and timestamps.

## Merge

Triggered by the client sending "merge A + B".

1. Take the higher-scoring concept as the base structure.
2. Pull the hook from the other concept if its hook scored higher.
3. Rewrite the beat map to hold together.
4. Score the merged concept on the full rubric.
5. Add as a new concept (id = A+B). Do not delete the originals.
6. Re-present the full table with the merge included.

A merge that scores below both originals is a failure and is recorded as such.

## Select

Triggered by a bare letter, or by /ms-concept-developer select <id>.

1. Verify the chosen concept scores >= 60 and >= 3 on Hook strength.
2. Set selectedId in concepts.json.
3. Write concept.md for the winner.
4. Move all other active concepts to status = "alternate".
5. Archive alternates to runs/<project-id>/concepts/alternates/<id>.json.
6. Emit the gate table and pass gate 3.

## Alternate

Triggered by /ms-concept-developer alternate <id>.

1. Verify the alternate still clears the floors.
2. Swap selectedId.
3. Re-write concept.md.
4. Re-open gate 3 and require re-approval.

## Archive

- Alternates are never deleted. They live in runs/<project-id>/concepts/alternates/.
- Killed concepts live in runs/<project-id>/concepts/killed/ with a reason.
- On pipeline rollback to stage 3, all archived concepts are restored as active.

## Stop conditions

Stop generating and present when:

- At least 3 concepts are scored and no two share a structural family
- One concept clears the recommended minimum of 75
- The client has selected one

Do not keep generating past the client's selection. Do not present a tie. Do not advance a concept that fails the floor.
