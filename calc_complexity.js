const bashParser = require('bash-parser');
var path = require('path');

function calculateCognitiveComplexity(node, level = 1, isFirstChild = true) {
    /**
     * Recursively calculates cognitive complexity based on the provided rules:
     * 1. + (level - 1) when the first subnode at a level appears or for each step in a pipeline.
     * 2. + 0.3 for every command node.
     * 3. + 0.02 for every character in awk expressions
     *
     * Args:
     *     node: A node from bash-parser
     *     level: Current depth level (starts at 1)
     *     isFirstChild: Whether this node is the first child at its level.
     *
     * Returns:
     *     The total cognitive complexity score.
     */
    let score = 0.0;

    // Rule 1: Break in linear flow when first subnode encountered
    if (isFirstChild && level > 1) {
        score += (level - 1);
    }

    // Rule 2: Every command node adds 0.3
    if (node.type === 'Command') {
        score += 0.3;

        if (node.name?.text === 'awk') {
            for (const suffix of node.suffix) {
                if (suffix.type === 'Word' && !suffix.text.startsWith('-')) {
                    score += 0.02 * suffix.text.length;
                    break;
                }
            }
        }
    }

    if (node.type === 'Pipeline' && node.commands) {
        depth = node.commands.length-1;
        progressionSum = depth/2*(level+depth);
        score += progressionSum;
    }
    // Collect children nodes
    const children = [];

    switch (node.type) {
      case 'Script':
          if (node.commands) children.push(...node.commands);
          break;
      case 'Pipeline':
          if (node.commands) {
            children.push(...node.commands);
            score -= level; // Since pipelines are already counted separately, offset by level that will be added in the next recursion
          }
          break;
      case 'LogicalExpression':
          if (node.left) children.push(node.left);
          if (node.right) children.push(node.right);
          break;
      case 'Command':
          if (node.prefix) children.push(...node.prefix);
          if (node.suffix) children.push(...node.suffix);
          break;
      case 'Function':
          if (node.body) children.push(node.body);
          break;
      case 'CompoundList':
          if (node.commands) children.push(node.commands);
          break;
      case 'Subshell':
          if (node.list) children.push(node.list);
          break;
      case 'If':
          if (node.clause) {
            children.push(...node.clause.commands);
          }
          if (node.then) {
            children.push(...node.then.commands);
          }
          if (node.else) {
            if (node.else.type === 'If') {
                children.push(node.else);
            } else if (node.else.type === 'CompoundList') {
                children.push(...node.else.commands);
            }
          }
          break;
      case 'For':
          if (node.do) children.push(...node.do.commands);
          if (node.wordlist) children.push(node.wordlist);
          break;
      case 'While':
      case 'Until':
          if (node.do) children.push(...node.do.commands);
          if (node.clause) {
              children.push(node.clause);
          }
          break;
      case 'Case':
          if (node.cases) {
              for (const caseItem of node.cases) {
                  if (caseItem.body) children.push(...caseItem.body.commands);
              }
          }
          break;
      case 'Wordlist':
        if (node.expansion) {
            children.push(...node.expansion);
        }
        break;
      case 'CommandExpansion':
        if (node.commandAST) {
            children.push(...node.commandAST.commands);
        }
      default:
          break;
  }

    for (let i = 0; i < children.length; i++) {
        score += calculateCognitiveComplexity(children[i], level + 1, i === 0);
    }

    return score;
}

function cognitiveComplexity(tree) {
    /**
     * Calculates total cognitive complexity for an entire parsed tree (list of top-level nodes).
     *
     * Args:
     *     tree: Output from bash-parser, typically an AST node.
     *
     * Returns:
     *     Total cognitive complexity score.
     */
    let total = 0.0;
    const topNodes = (tree.type === 'Script' && tree.commands) ? tree.commands : [tree];

    for (const node of topNodes) {
        total += calculateCognitiveComplexity(node);
    }
    return total;
}

function analyzeBashCode(bashCode) {
    var syntaxTree;
    try {
      syntaxTree = bashParser(bashCode);
    } catch (error) {
      return -1;
    }
    return cognitiveComplexity(syntaxTree);
}

var bashCode;
var bashScriptFile = process.argv[2];
if (bashScriptFile) {
  bashCode = require('fs').readFileSync(path.resolve(__dirname, 'scripts', bashScriptFile), 'utf8');
} else {
  console.error('Please provide a bash script file as an argument.');
}

console.log(analyzeBashCode(bashCode)); // Outputs the calculated cognitive complexity