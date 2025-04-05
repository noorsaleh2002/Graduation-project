from flask import Flask, request, jsonify
import google.generativeai as genai
import os
from document import process_document

app = Flask(__name__)

@app.route('/api/summarize', methods=['POST'])
def summarize_document():
    # Configure the Gemini API key
    genai.configure(api_key='AIzaSyCBufkBpX7glWU30DmyosmOzbHQmipEydM')

    model = genai.GenerativeModel('gemini-2.0-flash')

    # Log incoming request for debugging
    print("Incoming request:")
    print(f"Headers: {request.headers}")
    print(f"Form data: {request.form}")
    print(f"Files: {request.files}")
    
    # Get the uploaded document file
    document_file = request.files.get('document')

    # Check if a document file was provided
    if not document_file:
        print("Error: No document file provided")
        return jsonify({'error': 'No document file provided'}), 400

    # Read the document content and process it
    file_bytes = document_file.read()
    file_extension = os.path.splitext(document_file.filename)[1]
    
    try:
        document_content = process_document(file_bytes, file_extension)
    except ValueError as e:
        print(f"Error in processing document: {str(e)}")
        return jsonify({'error': str(e)}), 400

    # Get the summary length and detail level preference from the request
    summary_length = request.form.get('summaryLength', 0.5)
    detail_level = request.form.get('detailLevel', 2)

    try:
        summary_length = float(summary_length)
        detail_level = int(detail_level)
    except ValueError:
        print("Error: Invalid summary length or detail level")
        return jsonify({'error': 'Invalid summary length or detail level'}), 400

    # Define the prompt for generating the summary
    prompt = f"Summarize the following text and keep the summary within {summary_length*100}% of the original text length. Adjust the level of the detail based on the provided detail level ({detail_level}):\n\n{document_content}"

    # Try to generate the summary using the Gemini model
    try:
        print(f"Prompt: {prompt[:100]}...")  # Log the beginning of the prompt for debugging
        response = model.generate_content(prompt)
        summary = response.text
        print(f"Generated summary: {summary[:100]}...")  # Log the beginning of the summary
        return jsonify({'summary': summary})
    except Exception as e:
        print(f"Error generating summary: {str(e)}")
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
