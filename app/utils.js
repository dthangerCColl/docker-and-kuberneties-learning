// Utility functions that can be unit tested independently

/**
 * Validates that a user object has required fields
 * @param {Object} user - The user object to validate
 * @returns {Object} - { valid: boolean, errors: string[] }
 */
function validateUser(user) {
  const errors = [];

  if (!user) {
    return { valid: false, errors: ['User object is required'] };
  }

  if (!user.name || typeof user.name !== 'string') {
    errors.push('Name is required and must be a string');
  }

  if (!user.email || typeof user.email !== 'string') {
    errors.push('Email is required and must be a string');
  }

  if (user.email && !user.email.includes('@')) {
    errors.push('Email must be valid');
  }

  return {
    valid: errors.length === 0,
    errors: errors
  };
}

/**
 * Formats a user object for database storage
 * @param {Object} user - The user object
 * @param {number} userid - The user ID to assign
 * @returns {Object} - Formatted user object
 */
function formatUserForDb(user, userid) {
  return {
    ...user,
    userid: userid,
    updatedAt: new Date().toISOString()
  };
}

module.exports = {
  validateUser,
  formatUserForDb
};
