Note on Test Framework Selection for flake.lock validation

We looked for existing testing frameworks and aligned accordingly:
- If the file tests/test_flake_lock_validity.py exists, we append a pytest-based test suite (framework: pytest).
- Otherwise, we create __tests__/flake.lock.test.js for Jest (framework: Jest).

Both suites perform the following validations:
- Parse JSON
- Verify required top-level keys: nodes, root, and version
- Validate the schema of each node's 'locked' and 'original' sections
- Check the integrity of the root reference
- Assert support for lockfile version 7
- Ensure presence of critical nodes listed in the PR diff: nixpkgs-unstable, home-manager, lanzaboote, flake-parts, lix, lix-module, and ludovico-nixvim
- Basic shape checks for rev/url/narHash where present

Please adjust the "required dependencies" list if the diff or project requirements change.