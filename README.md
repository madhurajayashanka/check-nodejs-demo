# Node.js Express App with Docker

A simple Node.js Express application containerized with Docker.

## Features

- Express.js web server
- JSON API endpoints
- Health check endpoint
- Docker containerization
- Docker Compose for easy deployment
- Production-ready security practices

## API Endpoints

- `GET /` - Welcome message
- `GET /health` - Health check endpoint
- `GET /api/users` - Get list of users
- `POST /api/users` - Create a new user (requires name and email in JSON body)

## Quick Start

### Running with Docker Compose (Recommended)

1. Build and start the application:

   ```bash
   docker-compose up --build
   ```

2. The application will be available at `http://localhost:3000`

3. To stop the application:
   ```bash
   docker-compose down
   ```

### Running with Docker

1. Build the Docker image:

   ```bash
   docker build -t nodejs-express-app .
   ```

2. Run the container:
   ```bash
   docker run -p 3000:3000 nodejs-express-app
   ```

### Running Locally (Development)

1. Install dependencies:

   ```bash
   npm install
   ```

2. Start the development server:

   ```bash
   npm run dev
   ```

3. Or start the production server:
   ```bash
   npm start
   ```

## Development Mode with Docker

To run in development mode with hot reloading:

```bash
docker-compose --profile dev up --build
```

This will start the app on port 3001 with nodemon for auto-reloading.

## Testing the API

### Get welcome message:

```bash
curl http://localhost:3000/
```

### Check health:

```bash
curl http://localhost:3000/health
```

### Get users:

```bash
curl http://localhost:3000/api/users
```

### Create a user:

```bash
curl -X POST http://localhost:3000/api/users \
  -H "Content-Type: application/json" \
  -d '{"name": "John Doe", "email": "john@example.com"}'
```

## Project Structure

```
.
├── index.js              # Main application file
├── package.json           # Node.js dependencies and scripts
├── Dockerfile            # Docker image configuration
├── docker-compose.yml    # Docker Compose configuration
├── .dockerignore         # Files to ignore in Docker build
├── .gitignore           # Files to ignore in Git
└── README.md            # This file
```

## Environment Variables

- `PORT` - Port number (default: 3000)
- `NODE_ENV` - Environment mode (development/production)

## Docker Best Practices

This project implements several Docker best practices:

- Uses Alpine Linux for smaller image size
- Runs as non-root user for security
- Multi-stage build optimization
- Proper health checks
- Efficient layer caching with package.json copy
