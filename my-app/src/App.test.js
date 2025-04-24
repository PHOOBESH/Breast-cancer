import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import App from './App';
import axios from 'axios';

// Mock axios
jest.mock('axios');

describe('Breast Cancer Detection App', () => {
  beforeEach(() => {
    // Clear all mocks before each test
    jest.clearAllMocks();
  });

  test('renders the application title', () => {
    render(<App />);
    const titleElement = screen.getByText(/Breast Cancer Detection/i);
    expect(titleElement).toBeInTheDocument();
  });

  test('shows error when submitting without selecting an image', () => {
    render(<App />);
    
    // Find and click the submit button
    const submitButton = screen.getByText(/Upload Image/i);
    fireEvent.click(submitButton);
    
    // Check for error message
    const errorMessage = screen.getByText(/Please select an image before uploading/i);
    expect(errorMessage).toBeInTheDocument();
  });

  test('displays preview when image is selected', () => {
    render(<App />);
    
    // Create a mock file
    const file = new File(['dummy content'], 'test.png', { type: 'image/png' });
    
    // Mock FileReader
    const mockFileReader = {
      readAsDataURL: jest.fn(),
      onloadend: null,
      result: 'data:image/png;base64,dummybase64'
    };
    
    // Replace the global FileReader with our mock
    global.FileReader = jest.fn(() => mockFileReader);
    
    // Find the file input and simulate file selection
    const fileInput = screen.getByAcceptingUploadOf('image/*');
    fireEvent.change(fileInput, { target: { files: [file] } });
    
    // Manually trigger the onloadend event
    mockFileReader.onloadend();
    
    // Check for the preview image
    const previewImage = screen.getByAltText('preview');
    expect(previewImage).toBeInTheDocument();
    expect(previewImage.src).toBe(mockFileReader.result);
  });

  test('shows loading state and displays result on successful prediction', async () => {
    // Mock successful API response
    axios.post.mockResolvedValueOnce({
      data: { prediction: 'Non-Cancerous' }
    });
    
    render(<App />);
    
    // Create a mock file
    const file = new File(['dummy content'], 'test.png', { type: 'image/png' });
    
    // Mock FileReader
    const mockFileReader = {
      readAsDataURL: jest.fn(),
      onloadend: null,
      result: 'data:image/png;base64,dummybase64'
    };
    
    // Replace the global FileReader with our mock
    global.FileReader = jest.fn(() => mockFileReader);
    
    // Find the file input and simulate file selection
    const fileInput = screen.getByAcceptingUploadOf('image/*');
    fireEvent.change(fileInput, { target: { files: [file] } });
    
    // Manually trigger the onloadend event
    mockFileReader.onloadend();
    
    // Submit the form
    const submitButton = screen.getByText(/Upload Image/i);
    fireEvent.click(submitButton);
    
    // Check for loading state
    expect(screen.getByText(/Analyzing.../i)).toBeInTheDocument();
    
    // Wait for the result to be displayed
    await waitFor(() => {
      expect(screen.getByText(/Result: Non-Cancerous/i)).toBeInTheDocument();
    });
    
    // Verify axios was called correctly
    expect(axios.post).toHaveBeenCalledTimes(1);
    expect(axios.post.mock.calls[0][1]).toBeInstanceOf(FormData);
  });

  test('shows error message when API request fails', async () => {
    // Mock failed API response
    axios.post.mockRejectedValueOnce(new Error('Network error'));
    
    render(<App />);
    
    // Create a mock file
    const file = new File(['dummy content'], 'test.png', { type: 'image/png' });
    
    // Mock FileReader
    const mockFileReader = {
      readAsDataURL: jest.fn(),
      onloadend: null,
      result: 'data:image/png;base64,dummybase64'
    };
    
    // Replace the global FileReader with our mock
    global.FileReader = jest.fn(() => mockFileReader);
    
    // Find the file input and simulate file selection
    const fileInput = screen.getByAcceptingUploadOf('image/*');
    fireEvent.change(fileInput, { target: { files: [file] } });
    
    // Manually trigger the onloadend event
    mockFileReader.onloadend();
    
    // Submit the form
    const submitButton = screen.getByText(/Upload Image/i);
    fireEvent.click(submitButton);
    
    // Wait for the error message to be displayed
    await waitFor(() => {
      expect(screen.getByText(/Unable to connect to the server/i)).toBeInTheDocument();
    });
  });
});
