import path from 'path';
import { fileURLToPath } from 'url';
import minimist from 'minimist';

import { readYaml, mergeYamlFiles } from './utils/yaml-utils.js';
import { generateMarkdown } from './utils/markdown-utils.js';
import {
  findKubeBlueprintDir,
  findBlueprintYamlFiles,
} from './utils/file-utils.js';
import { writeMergedYaml } from './utils/debug-utils.js';

const currentFilename = fileURLToPath(import.meta.url);
const currentDirname = path.dirname(currentFilename);

/**
 * Arguments from the command line (optional)
 *
 * @type {Object}
 * @property {string} --blueprint-dir </path/to/blueprint-directory>- The parent directory of all the blueprint.yaml files. Default is the kube-blueprints parent directory.
 * @property {boolean} --merge-blueprints <true-or-false> - Flag to merge blueprint.yaml files. Default is false.
 * @property {boolean} --debug <true/false> - Flag to enable debug mode. To enable write of the merged blueprint.yaml files.
 */
const args = minimist(process.argv.slice(2), {
  string: ['blueprint-dir'],
  boolean: ['merge-blueprints'],
  alias: { 'blueprint-dir': 'b', 'merge-blueprints': 'm', debug: 'd' },
  default: { 'merge-blueprints': true, debug: false },
});

const blueprintDir =
  args['blueprint-dir'] || findKubeBlueprintDir(currentDirname);
const mergeBlueprints = args['merge-blueprints'] || true;
const debug = args['debug'];

function main(blueprintDir, mergeBlueprints) {
  let yamlFiles = findBlueprintYamlFiles(blueprintDir);

  if (yamlFiles.length === 0) {
    console.log('No blueprint.yaml files found.');
    return;
  }

  if (mergeBlueprints) {
    const mergedContent = mergeYamlFiles(yamlFiles);
    if (debug) {
      writeMergedYaml(currentDirname, mergedContent);
    }
    generateMarkdown(
      mergedContent.spec.parameters,
      path.join(blueprintDir, 'documentation', 'docs', 'blueprint.md'),
    );
  } else {
    yamlFiles.forEach((yamlFile) => {
      const yamlContent = readYaml(yamlFile);
      const parameters = yamlContent?.spec?.parameters || [];
      if (parameters.length > 0) {
        const outputFile = path.join(path.dirname(yamlFile), 'blueprint.md');
        generateMarkdown(parameters, outputFile);
      }
    });
  }
}

main(blueprintDir, mergeBlueprints);
