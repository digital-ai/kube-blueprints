import fs from 'fs';
import yaml from 'js-yaml';

const ExprType = new yaml.Type('!expr', {
  kind: 'scalar',
  construct: function (data) {
    return `!expr ${data}`;
  },
});

// Custom schema that includes the custom type
export const CUSTOM_SCHEMA = yaml.DEFAULT_SCHEMA.extend([ExprType]);

/**
 * Read the yaml file and return the content
 *
 * @param {string} filePath
 * @returns {Object}
 */
export function readYaml(filePath) {
  try {
    const fileContents = fs.readFileSync(filePath, 'utf8');
    return yaml.load(fileContents, { schema: CUSTOM_SCHEMA });
  } catch (e) {
    console.log(e);
    return null;
  }
}

/**
 * Merge the content of multiple yaml files
 *
 * @param {Array<string>} yamlFiles
 * @returns {Object}
 */
export function mergeYamlFiles(yamlFiles) {
  let mergedContent = { spec: { parameters: [] } };
  yamlFiles.forEach((file) => {
    const content = readYaml(file);
    if (content && content.spec && content.spec.parameters) {
      mergedContent.spec.parameters.push(...content.spec.parameters);
    }
  });
  return mergedContent;
}
