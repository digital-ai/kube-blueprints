import { CUSTOM_SCHEMA } from './yaml-utils.js';
import fs from 'fs';
import path from 'path';
import yaml from 'js-yaml';

export function writeMergedYaml(currentDirname, mergedContent) {
  const outputFile = path.join(currentDirname, 'merged_blueprint.yaml');
  fs.writeFileSync(
    outputFile,
    yaml.dump(mergedContent, { schema: CUSTOM_SCHEMA }),
  );
}
