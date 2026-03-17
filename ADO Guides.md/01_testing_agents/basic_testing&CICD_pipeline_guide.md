# Basic Testing & CI/CD Pipeline Guide

A step-by-step guide to setting up testing and GitHub Actions CI/CD for a Node.js + Express + MongoDB application.

---

## Overview

This guide covers:

1. **ESLint** - Code linting (static analysis)
2. **Jest** - Unit testing framework
3. **Supertest** - Integration testing for APIs
4. **GitHub Actions** - CI/CD pipeline automation

---

## Prerequisites

- Node.js project with Express
- Docker and docker-compose for MongoDB
- GitHub repository

---

## Part 1: Setting Up ESLint (Linting)

### What is ESLint?

ESLint analyzes your JavaScript code *without running it* and catches:

- Syntax errors
- Undefined variables
- Unused variables
- Style inconsistencies

### Step 1: Update package.json for ESLint

Add ESLint to devDependencies and create a lint script:

```json
{
  "scripts": {
    "lint": "eslint ."
  },
  "devDependencies": {
    "eslint": "^8.57.0"
  }
}
```

### Step 2: Create ESLint Configuration

Create `app/eslint.config.js`:

```javascript
module.exports = [
  {
    files: ["**/*.js"],
    ignores: ["node_modules/**"],
    languageOptions: {
      ecmaVersion: 2020,
      sourceType: "commonjs",
      globals: {
        // Node.js globals
        require: "readonly",
        module: "readonly",
        process: "readonly",
        __dirname: "readonly",
        console: "readonly",
        // Jest globals (for test files)
        describe: "readonly",
        test: "readonly",
        expect: "readonly",
        beforeEach: "readonly",
        afterEach: "readonly",
        beforeAll: "readonly",
        afterAll: "readonly",
        jest: "readonly"
      }
    },
    rules: {
      "no-unused-vars": "warn",
      "no-undef": "error",
      "no-console": "off",
      "semi": ["warn", "always"],
      "eqeqeq": "warn"
    }
  }
];
```

### Step 3: Install and Test

```bash
cd app
npm install
npm run lint
```

---

## Part 2: Setting Up Jest (Unit Testing)

### What is Jest?

Jest is a testing framework that lets you write tests to verify your code works correctly.

### Step 1: Update package.json for Jest

```json
{
  "scripts": {
    "test": "jest"
  },
  "devDependencies": {
    "jest": "^29.7.0"
  }
}
```

### Step 2: Create Testable Utility Functions

Create `app/utils.js` with pure functions that can be tested:

```javascript
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
  return { valid: errors.length === 0, errors: errors };
}

module.exports = { validateUser };
```

### Step 3: Create Test File

Create `app/utils.test.js`:

```javascript
const { validateUser } = require('./utils');

describe('validateUser', () => {
  test('returns invalid when user is null', () => {
    const result = validateUser(null);
    expect(result.valid).toBe(false);
    expect(result.errors).toContain('User object is required');
  });

  test('returns valid for correct user object', () => {
    const result = validateUser({ name: 'John', email: 'john@example.com' });
    expect(result.valid).toBe(true);
    expect(result.errors).toHaveLength(0);
  });
});
```

### Step 4: Run Tests

```bash
npm test
```

---

## Part 3: Integration Testing with Supertest

### What is Supertest?

Supertest lets you make HTTP requests to your Express app in tests.

### Step 1: Add Supertest

```json
{
  "devDependencies": {
    "supertest": "^6.3.3"
  }
}
```

### Step 2: Modify server.js for Testing

Add at the end of `server.js`:

```javascript
// Only start the server if this file is run directly (not imported)
if (require.main === module) {
  app.listen(3000, function () {
    console.log("app listening on port 3000!");
  });
}

// Export the app for testing
module.exports = app;
```

### Step 3: Create Integration Tests

Create `app/server.integration.test.js`:

```javascript
const request = require('supertest');
const app = require('./server');

// Increase timeout for integration tests
jest.setTimeout(30000);

describe('API Integration Tests', () => {
  describe('GET /', () => {
    test('should return 200 and HTML content', async () => {
      const response = await request(app).get('/');
      expect(response.status).toBe(200);
      expect(response.headers['content-type']).toMatch(/html/);
    });
  });

  describe('POST /update-profile', () => {
    test('should accept profile data and return it', async () => {
      const profileData = { name: 'Test User', email: 'test@example.com' };
      const response = await request(app)
        .post('/update-profile')
        .send(profileData)
        .set('Content-Type', 'application/json');
      expect(response.status).toBe(200);
      expect(response.body.name).toBe('Test User');
    });
  });
});
```

### Step 4: Run with MongoDB

```bash
docker-compose up -d    # Start MongoDB
npm test                # Run tests
```

---

## Part 4: GitHub Actions CI/CD Pipeline

### What is GitHub Actions?

GitHub's built-in CI/CD system that runs workflows automatically on push/PR events.

### Step 1: Create Workflow Directory

```bash
mkdir -p .github/workflows
```

### Step 2: Create Workflow File

Create `.github/workflows/ci.yml`:

```yaml
name: CI

on:
  push:
    branches: [dev, test, master]
  pull_request:
    branches: [dev, test, master]

jobs:
  lint-and-test:
    runs-on: ubuntu-latest

    services:
      mongodb:
        image: mongo:6
        ports:
          - 27017:27017
        env:
          MONGO_INITDB_ROOT_USERNAME: admin
          MONGO_INITDB_ROOT_PASSWORD: password
        options: >-
          --health-cmd "mongosh -u admin -p password --authenticationDatabase admin --eval 'db.runCommand({ping:1})' --quiet"
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5

    env:
      MONGO_URL: mongodb://admin:password@localhost:27017

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Wait for MongoDB
        run: |
          for i in {1..30}; do
            if nc -z localhost 27017; then
              echo "MongoDB is up!"
              exit 0
            fi
            echo "Waiting for MongoDB... ($i)"
            sleep 1
          done
          echo "MongoDB failed to start"
          exit 1

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '22'
          cache: 'npm'
          cache-dependency-path: app/package-lock.json

      - name: Install dependencies
        working-directory: ./app
        run: npm ci

      - name: Run ESLint
        working-directory: ./app
        run: npm run lint

      - name: Run tests
        working-directory: ./app
        run: npm test

  build-docker:
    runs-on: ubuntu-latest
    needs: lint-and-test

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Build Docker image
        uses: docker/build-push-action@v5
        with:
          context: .
          push: false
          tags: docker-and-kubernetes-learning:${{ github.sha }}
```

---

## Part 5: Git Workflow Commands

### Daily Development Flow

```bash
# 1. Check what changed
git status

# 2. See line-by-line changes
git diff

# 3. Stage changes
git add .                    # All files
git add <filename>           # Specific file

# 4. Commit
git commit -m "Your message"

# 5. Push to GitHub
git push origin dev
```

### Useful Git Commands

| Command | Purpose |
| ------- | ------- |
| `git status` | See changed files |
| `git diff` | See line changes (press `q` to exit) |
| `git add .` | Stage all changes |
| `git commit -m "msg"` | Commit with message |
| `git push origin <branch>` | Push to remote |
| `git log --oneline -5` | See recent commits |

---

## Part 6: SSH Key Setup for GitHub

### Step 1: Generate SSH Key

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
```

Press Enter for defaults.

### Step 2: Copy Public Key

```bash
cat ~/.ssh/id_ed25519.pub | pbcopy
```

### Step 3: Add to GitHub

1. Go to <https://github.com/settings/keys>
2. Click "New SSH key"
3. Paste the key
4. Click "Add SSH key"

### Step 4: Update Remote URL

```bash
git remote set-url origin git@github.com:USERNAME/REPO.git
```

### Step 5: Add GitHub to Known Hosts

```bash
ssh-keyscan github.com >> ~/.ssh/known_hosts
```

### Step 6: Test Connection

```bash
ssh -T git@github.com
```

---

## Quick Reference: Final package.json

```json
{
  "name": "docker-and-kubernetes-learning",
  "version": "1.0.0",
  "main": "server.js",
  "scripts": {
    "test": "jest",
    "start": "node server.js",
    "lint": "eslint ."
  },
  "dependencies": {
    "body-parser": "^1.19.0",
    "express": "^4.17.1",
    "mongodb": "^3.3.3"
  },
  "devDependencies": {
    "eslint": "^8.57.0",
    "jest": "^29.7.0",
    "supertest": "^6.3.3"
  }
}
```

---

## Pipeline Flow Diagram

```text
Push to dev/test/master
        │
        ▼
┌─────────────────┐
│  lint-and-test  │
│  - npm ci       │
│  - npm run lint │
│  - npm test     │
└────────┬────────┘
         │ (if passes)
         ▼
┌─────────────────┐
│  build-docker   │
│  - Build image  │
└─────────────────┘
```

---

## Troubleshooting

### ESLint: 'describe' is not defined

Add Jest globals to `eslint.config.js` globals section.

### Tests timeout in CI

- Add MongoDB health check to workflow
- Increase Jest timeout: `jest.setTimeout(30000)`
- Add "Wait for MongoDB" step

### Git push authentication failed

- Use SSH keys instead of HTTPS
- Or use GitHub CLI: `gh auth login`

---

## Key Concepts Summary

| Term | Meaning |
| ---- | ------- |
| **Linting** | Static code analysis (finds bugs without running code) |
| **Unit Tests** | Test individual functions in isolation |
| **Integration Tests** | Test components working together |
| **CI/CD** | Continuous Integration/Continuous Deployment |
| **Service Container** | Docker container spun up for tests (e.g., MongoDB) |
| **Health Check** | Verifies service is ready before tests run |

---

Guide created from hands-on session - November 2024
