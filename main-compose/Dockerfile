FROM python:3.10.2-alpine AS builder

WORKDIR /app

COPY requirements.txt .

# Install build dependencies and application dependencies
RUN apk add --no-cache build-base mariadb-dev pkgconfig && \
    pip install --no-cache-dir --user -r requirements.txt 

# Runtime stage
FROM python:3.10.2-alpine

WORKDIR /app

# Copy installed dependencies from the builder stage
COPY --from=builder /root/.local /root/.local

# Copy the application code
COPY . /app

EXPOSE 5000

# Command to run the application
CMD ["python", "/app/app.py"]