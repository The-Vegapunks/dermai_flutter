# DermAI - Documentation

**DermAI** is an innovative healthcare application designed to connect patients with dermatologists and provide AI-driven image classification for skin conditions. The app combines advanced machine learning algorithms with telemedicine to offer instant preliminary diagnoses, health guidance through a chatbot, and seamless appointment scheduling with dermatologists. It also supports secure video consultations, making dermatological care accessible from anywhere.

## Features
- **AI-Driven Image Classification**: Instant preliminary diagnoses for skin conditions using machine learning.
- **Chatbot**: Provides health guidance and support.
- **Appointment Scheduling**: Seamless integration with dermatologists' schedules.
- **Secure Video Consultations**: Enabling remote dermatological care.
  
## Prerequisites

Before you can build and run the DermAI app, ensure you have the following installed on your development environment:

- **Flutter SDK**: [Install Flutter](https://flutter.dev/docs/get-started/install)
- **Dart SDK**: Usually included with Flutter.
- **Python**: [Install Python](https://www.python.org/downloads/)
- **Flask**: Install Flask via pip (`pip install flask`)
- **Ngrok**: [Install Ngrok](https://ngrok.com/download)
- **Git**: [Install Git](https://git-scm.com/downloads)
- **Supabase**: Create an account on [Supabase](https://supabase.io/) and set up a project.
  
## AI Server Setup

The AI image classification server is a crucial component of DermAI. Here's how to set it up:

1. **Clone the AI Server Repository**:  
   Clone the AI server repository from GitHub:
   ```bash
   git clone https://github.com/poshan-p/dermai.git
   cd dermai
   ```

2. **Install Dependencies**:  
   Install the necessary Python packages:
   ```bash
   pip install -r requirements.txt
   ```

3. **Run the AI Server**:  
   Start the Flask server to serve the AI model:
   ```bash
   flask run
   ```

4. **Expose the AI Server Using Ngrok**:  
   Use Ngrok to expose the Flask server to the internet:
   ```bash
   ngrok http 5000
   ```
   Copy the generated public URL (e.g., `https://xxxxxx.ngrok.io`) and save it for later use.

## Setting Up the Flutter App

1. **Clone the DermAI Repository**:  
   Clone the DermAI Flutter project:
   ```bash
   git clone https://github.com/poshan-p/dermai_flutter.git
   cd dermai_flutter
   ```

2. **Create a `.env` File**:  
   In the root directory of the DermAI Flutter project, create a `.env` file with the following content:
   ```
   SUPERBASEURL=<Your Supabase URL>
   SUPABASEANONKEY=<Your Supabase Anon Key>
   GEMINIKEY=<Your Gemini API Key>
   DISEASECLASSIFIERURL=<Ngrok URL from AI Server Setup>
   STREAMAPIKEY=<Your Stream API Key>
   ```

3. **Configure Supabase**:  
   Set up your Supabase project according to your needs. You can define your database schema using the model classes provided in the project.

4. **Generate Environment Configuration**:  
   Run the following command to generate files that include your environment variables:
   ```bash
   dart run build_runner build
   ```

5. **Build the App**:  
   Use Flutter to build the app for Android or iOS:
   - For Android:
     ```bash
     flutter build apk
     ```
   - For iOS:
     ```bash
     flutter build ios
     ```

6. **Run the App**:  
   Run the app on an emulator or connected device:
   ```bash
   flutter run
   ```

## Conclusion

You have successfully set up and run the DermAI application. The app is now ready to provide dermatological care powered by AI and telemedicine. Please refer to the project documentation or contact the development team if you encounter any issues.