import nlp from 'compromise';

/**
 * Removes the period in the end of sentence in description for readability
 *
 * @param {string} text
 * @returns {string}
 */
export function trimPeriod(text) {
  if (text.endsWith('.')) {
    return text.slice(0, -1);
  }
  return text;
}

/**
 * To form continuous sentences, makes the first letter lowercase if it's uppercase
 * For example, "This is a description." -> "this is a description."
 *
 * @param {string} text
 * @returns {string}
 */
export function beginWithLowerCase(text) {
  if (text.length > 0 && text[0] === text[0].toUpperCase()) {
    return text[0].toLowerCase() + text.slice(1);
  }
  return text;
}

/**
 * Truncate the description to the first comma in the first sentence
 *
 * @param {string} description
 * @returns {string}
 */
export function truncateDescription(description) {
  let doc = nlp(description);
  let firstSentence = doc.sentences().first().out('text');

  let commaIndex = firstSentence.indexOf(',');
  if (commaIndex !== -1) {
    firstSentence = firstSentence.slice(0, commaIndex);
  }

  return firstSentence;
}

/**
 * Concise description to a single sentence
 *
 * @param {string} description
 * @returns {string}
 */
export function concise(description) {
  description = truncateDescription(description);
  description = beginWithLowerCase(description);
  description = trimPeriod(description);
  return description;
}

/**
 * Process the field containing !expr to return actual expr string
 *
 * @param {string} field containing !expr
 * @returns {string} actual expression following !expr
 */
export function processExprField(field) {
  if (!field) {
    return null;
  }
  let expr = field;
  if (field.includes('!expr')) {
    expr = field.split('!expr')[1].trim();
  }
  return expr;
}

/**
 * Concatenate the expr string into a single string where it contains + operator
 *
 * @param {string} field
 * @returns {string} concatenated string
 */
export function processExprFieldWithConcatenation(field) {
  let expr = processExprField(field);
  if (expr && expr.includes('+')) {
    expr = expr
      .split('+')
      .map((part) =>
        part.trim().startsWith("'") && part.trim().endsWith("'")
          ? part.trim().slice(1, -1).trim()
          : part.trim(),
      )
      .join(' ')
      .trim();
    return expr;
  }
  return expr;
}

/**
 * Process the promptIf field to return plain english
 * Experimental: Not used
 *  
 * @param {string} field
 * @param {Array<Object>} parameters
 * @returns {string}
 */
export function processFieldPromptIf(field, parameters) {
  let expr = processExprField(field);
  if (!expr) {
    return 'N/A';
  }
  parameters.forEach((param) => {
    if (expr.includes(param.name)) {
      let description = param.description || param.name || '';
      if (param.description) {
        description = concise(processExprFieldWithConcatenation(description));
      }
      expr = expr.replace(new RegExp(`\\b${param.name}\\b`, 'g'), description);
    }
  });

  expr = expr.replace(/==/g, 'is');
  expr = expr.replace(/!=/g, 'is not');
  expr = expr.replace(/&&/g, 'and');
  expr = expr.replace(/\|\|/g, 'or');
  expr = expr.replace(/!/g, 'not ');
  // Not removing the brackets for readability
  // expr = expr.replace(/\(/g, '');
  // expr = expr.replace(/\)/g, '');
  expr = expr.replace(/'/g, '');
  expr = expr.replace(/"/g, '');
  expr = expr.replace(/=/g, 'equals');
  expr = expr.replace(/</g, 'less than');
  expr = expr.replace(/>/g, 'greater than');
  expr = expr.replace(/<=/g, 'less than or equals');
  expr = expr.replace(/>=/g, 'greater than or equals');

  let doc = nlp(expr);
  let plainEnglish = doc.out('text');

  plainEnglish = plainEnglish.charAt(0).toUpperCase() + plainEnglish.slice(1);
  if (!plainEnglish.endsWith('.')) {
    plainEnglish += '.';
  }

  return plainEnglish;
}

/**
 * List of valid platforms
 *
 * @param {string} promptIf
 * @returns {Array<string>}
 */
export function extractPlatform(promptIf) {
  const platforms = ['EKS', 'AKS', 'GKE', 'Openshift', 'OpenshiftCertified', 'PlainK8s'];
  let validPlatforms = platforms;
  const regexPattern = /regex\('\^Openshift\.\*', K8sSetup\)/;
  if (regexPattern.test(promptIf)) {
    validPlatforms = platforms.filter((p) => /^Openshift.*/.test(p));
  }

  return platforms;
}

/**
 * Convert PascalCase to space-separated words
 *
 * @param {string} pascalCaseString
 * @returns {string}
 */
export function pascalCaseToWords(pascalCaseString) {
  return pascalCaseString.replace(/([A-Z][a-z]+)/g, ' $1').trim();
}
