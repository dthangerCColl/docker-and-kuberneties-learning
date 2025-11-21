const request = require('supertest');
const app = require('./server');

describe('API Integration Tests', () => {

  // Test the home page
  describe('GET /', () => {
    test('should return 200 and HTML content', async () => {
      const response = await request(app).get('/');
      expect(response.status).toBe(200);
      expect(response.headers['content-type']).toMatch(/html/);
    });
  });

  // Test profile picture endpoint
  describe('GET /profile-picture', () => {
    test('should return 200 and image content', async () => {
      const response = await request(app).get('/profile-picture');
      expect(response.status).toBe(200);
      expect(response.headers['content-type']).toMatch(/image/);
    });
  });

  // Test update profile endpoint (requires MongoDB)
  describe('POST /update-profile', () => {
    test('should accept profile data and return it', async () => {
      const profileData = {
        name: 'Test User',
        email: 'test@example.com',
        interests: 'Testing'
      };

      const response = await request(app)
        .post('/update-profile')
        .send(profileData)
        .set('Content-Type', 'application/json');

      expect(response.status).toBe(200);
      expect(response.body.name).toBe('Test User');
      expect(response.body.email).toBe('test@example.com');
      // Note: userid is added server-side but response is sent before DB callback
      // So we just verify the profile data was echoed back
    });
  });

  // Test get profile endpoint (requires MongoDB)
  describe('GET /get-profile', () => {
    test('should return profile data', async () => {
      const response = await request(app).get('/get-profile');
      expect(response.status).toBe(200);
      // Response will be {} if no profile exists, or the profile object
      expect(typeof response.body).toBe('object');
    });
  });

});
