# Use official TensorFlow image to avoid compatibility issues
FROM tensorflow/tensorflow:2.10.0

# Set working directory
WORKDIR /app

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Flask and other dependencies first
RUN pip install --no-cache-dir flask flask-cors pillow numpy

# Install gdown for downloading the model
RUN pip install --no-cache-dir gdown

# Copy requirements file
COPY requirements.txt .

# Download model file
RUN gdown https://drive.google.com/uc?id=1vuuDocQ6HaxRAuXo1s_ZdjQenPMHFbgl -O my_model3.h5 && \
    ls -la my_model3.h5

# Copy application code
COPY app.py .

# Expose port
EXPOSE 5000

# Run the application
CMD ["python", "app.py"]
