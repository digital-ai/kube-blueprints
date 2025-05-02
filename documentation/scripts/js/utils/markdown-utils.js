import fs from 'fs';
import { sprintf } from 'sprintf-js';
import {
  extractPlatform,
  processExprField,
  processExprFieldWithConcatenation,
  pascalCaseToWords,
} from './field-utils.js';

/**
 * Generate markdown file for the given parameters
 *
 * @param {Array<Object>} parameters
 * @param {string} outputFilePath
 */
export function generateMarkdown(parameters, outputFile) {
  let markdownContent = '# Kube Blueprint Parameters Documentation\n\n';

  parameters.forEach((param) => {
    // skip the param for doc if prompt is not present
    if (!param.prompt) {
      return;
    }
    markdownContent += sprintf('## %s\n', pascalCaseToWords(param.name));

    markdownContent += sprintf(
      '**Prompt:** `%s`\n\n',
      processExprFieldWithConcatenation(param.prompt) || 'N/A',
    );
    markdownContent += sprintf('**Type of Prompt:** %s\n\n', param.type);

    const platform = extractPlatform(param.promptIf || '');
    markdownContent += sprintf('**Platform:** %s\n\n', platform.join(', '));

    markdownContent += '**Available Values:** ';
    if (param.type === 'Confirm') {
      markdownContent += 'Yes/No\n';
    } else if (param.options) {
      markdownContent += '\n';
      // options can be in the format option['label'] and option['value'] or just list of strings
      param.options.forEach((option) => {
        if (typeof option === 'string') {
          markdownContent += sprintf('- %s\n', processExprField(option));
        } else {
          markdownContent += sprintf(
            '- **%s**: %s\n',
            option.label,
            option.value,
          );
        }
      });
    } else {
      markdownContent += 'N/A\n';
    }

    let defaultValue = (param.default !== undefined && param.default !== null) ? String(param.default) : 'N/A';
    if (defaultValue.startsWith('!expr')) {
      markdownContent += '\n**Default Value:** N/A\n\n';
    } else if (defaultValue.split('\n').length > 1) {
      markdownContent += sprintf(
        '\n**Default Value:**\n```\n%s\n```\n\n',
        defaultValue,
      );
    } else {
      markdownContent += sprintf('\n**Default Value:** %s\n\n', defaultValue);
    }

    markdownContent += sprintf(
      '**Description:** %s\n\n',
      processExprFieldWithConcatenation(param.description) || 'N/A',
    );
    markdownContent += '\n';
  });

  fs.writeFileSync(outputFile, markdownContent);
}
