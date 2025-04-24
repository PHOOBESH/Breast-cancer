import os
import sys
import pytest
import json
from io import BytesIO
from PIL import Image
import numpy as np

# Add the parent directory to sys.path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

# Import the Flask app
from app import app, preprocess_image

@pytest.fixture
def client():
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client

def test_health_check(client):
    """Test the health check endpoint"""
    response = client.get('/')
    assert response.status_code == 200
    data = json.loads(response.data)
    assert data['status'] == 'healthy'
    assert 'message' in data

def test_predict_no_image(client):
    """Test prediction endpoint with no image"""
    response = client.post('/predict')
    assert response.status_code == 400
    data = json.loads(response.data)
    assert 'error' in data

def test_predict_empty_filename(client):
    """Test prediction endpoint with empty filename"""
    response = client.post('/predict', data={
        'image': (BytesIO(), '')
    }, content_type='multipart/form-data')
    assert response.status_code == 400
    data = json.loads(response.data)
    assert 'error' in data

def test_preprocess_image():
    """Test the image preprocessing function"""
    # Create a test image
    img = Image.new('RGB', (100, 100), color='red')
    img_io = BytesIO()
    img.save(img_io, 'JPEG')
    img_io.seek(0)
    
    # Process the image
    result = preprocess_image(img_io)
    
    # Check the result
    assert isinstance(result, np.ndarray)
    assert result.shape == (1, 512, 512, 3)
    assert result.dtype == np.float64
    assert 0 <= result.min() <= result.max() <= 1  # Values should be normalized
