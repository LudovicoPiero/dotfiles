/**
 * Test suite for validating the Nix flake.lock file.
 *
 * Framework: Jest (JavaScript)
 * - Focus on validating schema and critical nodes indicated by the PR diff.
 * - Tests are deterministic and do not require network access.
 */

const fs = require('fs');

describe('flake.lock', () => {
  let raw;
  let lock;

  beforeAll(() => {
    expect(fs.existsSync('flake.lock')).toBe(true);
    raw = fs.readFileSync('flake.lock', 'utf-8');
    expect(() => JSON.parse(raw)).not.toThrow();
    lock = JSON.parse(raw);
  });

  test('has required top-level structure', () => {
    expect(lock && typeof lock).toBe('object');
    expect(lock).toHaveProperty('nodes');
    expect(lock).toHaveProperty('root');
    expect(lock).toHaveProperty('version');
    expect(typeof lock.nodes).toBe('object');
    expect(typeof lock.root).toBe('string');
    expect(typeof lock.version).toBe('number');
  });

  test('supported lockfile version', () => {
    expect([7]).toContain(lock.version);
  });

  test('root references a valid node', () => {
    expect(lock.nodes).toHaveProperty(lock.root);
  });

  test('nodes have expected structure', () => {
    Object.entries(lock.nodes).forEach(([name, node]) => {
      expect(node && typeof node).toBe('object');
      expect(node.locked || node.original).toBeTruthy();
      if (node.locked) {
        expect(typeof node.locked).toBe('object');
        expect(node.locked).toHaveProperty('type');
        ['owner', 'repo', 'rev', 'narHash', 'lastModified', 'url'].forEach(k => {
          if (k in node.locked) {
            expect(node.locked[k]).not.toBeNull();
          }
        });
      }
      if (node.original) {
        expect(typeof node.original).toBe('object');
        expect(node.original).toHaveProperty('type');
      }
    });
  });

  test('required dependencies from PR diff exist', () => {
    const required = [
      'nixpkgs-unstable',
      'home-manager',
      'lanzaboote',
      'flake-parts',
      'lix',
      'lix-module',
      'ludovico-nixvim',
    ];
    required.forEach(dep => expect(lock.nodes).toHaveProperty(dep));
  });

  test('git-like locked nodes have SHA-shaped rev', () => {
    Object.entries(lock.nodes).forEach(([name, node]) => {
      const rev = node?.locked?.rev;
      if (typeof rev === 'string') {
        expect(/^[0-9a-fA-F]{7,}$/.test(rev)).toBe(true);
      }
    });
  });

  test('hashes/urls present are non-empty strings', () => {
    Object.entries(lock.nodes).forEach(([name, node]) => {
      const locked = node?.locked || {};
      ['url', 'narHash'].forEach(key => {
        if (key in locked) {
          expect(typeof locked[key]).toBe('string');
          expect(locked[key].trim()).not.toHaveLength(0);
        }
      });
    });
  });
});