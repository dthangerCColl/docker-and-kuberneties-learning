const { validateUser, formatUserForDb } = require('./utils');

describe('validateUser', () => {
  test('returns invalid when user is null', () => {
    const result = validateUser(null);
    expect(result.valid).toBe(false);
    expect(result.errors).toContain('User object is required');
  });

  test('returns invalid when name is missing', () => {
    const result = validateUser({ email: 'test@example.com' });
    expect(result.valid).toBe(false);
    expect(result.errors).toContain('Name is required and must be a string');
  });

  test('returns invalid when email is missing', () => {
    const result = validateUser({ name: 'John' });
    expect(result.valid).toBe(false);
    expect(result.errors).toContain('Email is required and must be a string');
  });

  test('returns invalid when email format is wrong', () => {
    const result = validateUser({ name: 'John', email: 'invalid-email' });
    expect(result.valid).toBe(false);
    expect(result.errors).toContain('Email must be valid');
  });

  test('returns valid for correct user object', () => {
    const result = validateUser({ name: 'John', email: 'john@example.com' });
    expect(result.valid).toBe(true);
    expect(result.errors).toHaveLength(0);
  });
});

describe('formatUserForDb', () => {
  test('adds userid to user object', () => {
    const user = { name: 'John', email: 'john@example.com' };
    const result = formatUserForDb(user, 123);
    expect(result.userid).toBe(123);
  });

  test('adds updatedAt timestamp', () => {
    const user = { name: 'John', email: 'john@example.com' };
    const result = formatUserForDb(user, 1);
    expect(result.updatedAt).toBeDefined();
  });

  test('preserves original user properties', () => {
    const user = { name: 'John', email: 'john@example.com' };
    const result = formatUserForDb(user, 1);
    expect(result.name).toBe('John');
    expect(result.email).toBe('john@example.com');
  });
});
