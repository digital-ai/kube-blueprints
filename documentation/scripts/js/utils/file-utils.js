import fs from 'fs';
import path from 'path';

export function findKubeBlueprintDir(currentDir) {
  while (currentDir !== path.parse(currentDir).root) {
    if (path.basename(currentDir) === 'kube-blueprints') {
      return currentDir;
    }
    currentDir = path.dirname(currentDir);
  }
  throw new Error('kube-blueprints directory not found');
}

export function findBlueprintYamlFiles(blueprintDir) {
  let yamlFiles = [];
  fs.readdirSync(blueprintDir).forEach((file) => {
    const fullPath = path.join(blueprintDir, file);
    if (fs.lstatSync(fullPath).isDirectory()) {
      const blueprintFile = path.join(fullPath, 'blueprint.yaml');
      if (fs.existsSync(blueprintFile)) {
        yamlFiles.push(blueprintFile);
      }
    }
  });
  return yamlFiles;
}
