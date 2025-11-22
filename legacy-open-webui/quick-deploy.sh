#!/bin/bash

# ==============================================
# Quick Deploy Script - AI Models to Free Platforms
# ==============================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Free AI Cloud Deployment Assistant${NC}"
echo -e "${BLUE}====================================${NC}"

# Platform options
declare -A platforms=(
    ["1"]="Hugging Face Spaces"
    ["2"]="Google Colab"
    ["3"]="Replicate"
    ["4"]="Paperspace Gradient"
    ["5"]="Modal"
)

declare -A pros=(
    ["1"]="Unlimited public deployment, Easy setup"
    ["2"]="Free GPU access, Jupyter environment"
    ["3"]="Serverless scaling, API-first"
    ["4"]="Professional MLOps features"
    ["5"]="Powerful GPU options, Fast cold start"
)

declare -A cons=(
    ["1"]="Limited GPU time, Cold start slow"
    ["2"]="Session timeout 12h, Unpredictable limits"
    ["3"]="Limited free credits"
    ["4"]="Credit-based, Email verification needed"
    ["5"]="Trial credits limited"
)

declare -A signup_urls=(
    ["1"]="https://huggingface.co/join"
    ["2"]="https://colab.research.google.com/"
    ["3"]="https://replicate.com/signup"
    ["4"]="https://www.paperspace.com/gradient"
    ["5"]="https://modal.com/signup"
)

declare -A docs_urls=(
    ["1"]="https://huggingface.co/docs/spaces"
    ["2"]="https://colab.research.google.com/notebooks/intro.ipynb"
    ["3"]="https://replicate.com/docs"
    ["4"]="https://docs.paperspace.com/gradient/"
    ["5"]="https://modal.com/docs"
)

# Model recommendations
declare -A recommended_models=(
    ["1"]="microsoft/DialoGPT-medium"
    ["2"]="gpt2"
    ["3"]="stability-ai/stable-diffusion"
    ["4"]="facebook/opt-125m"
    ["5"]="microsoft/DialoGPT-large"
)

# Function to display platform info
show_platform_info() {
    local choice=$1
    echo -e "\n${YELLOW}📋 Thông tin chi tiết về ${platforms[$choice]}:${NC}"
    echo -e "${GREEN}✅ Ưu điểm:${NC} ${pros[$choice]}"
    echo -e "${RED}❌ Nhược điểm:${NC} ${cons[$choice]}"
    echo -e "${BLUE}🔗 Sign up:${NC} ${signup_urls[$choice]}"
    echo -e "${BLUE}📚 Documentation:${NC} ${docs_urls[$choice]}"
    echo -e "${BLUE}🎯 Model khuyến nghị:${NC} ${recommended_models[$choice]}"
}

# Function to generate deployment code
generate_deployment_code() {
    local platform=$1
    local model=$2
    
    case $platform in
        "1") # Hugging Face Spaces
            cat > app.py << 'EOF'
import gradio as gr
from transformers import pipeline

# Load model
pipe = pipeline("text-generation", model="microsoft/DialoGPT-medium")

def predict(text):
    if not text.strip():
        return "Please enter some text"
    
    result = pipe(text, max_length=100, do_sample=True, temperature=0.7)
    return result[0]['generated_text']

# Create Gradio interface
demo = gr.Interface(
    fn=predict,
    inputs=gr.Textbox(lines=2, placeholder="Type your message..."),
    outputs=gr.Textbox(label="Response"),
    title="AI Chatbot Demo",
    description="Powered by microsoft/DialoGPT-medium model"
)

if __name__ == "__main__":
    demo.launch()
EOF
            cat > requirements.txt << 'EOF'
transformers>=4.20.0
torch>=1.11.0
gradio>=3.0.0
EOF
            echo -e "${GREEN}✅ Generated HF Spaces files: app.py, requirements.txt${NC}"
            ;;
            
        "2") # Google Colab
            cat > colab_demo.ipynb << 'EOF'
{
 "cells": [
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "# AI Model Demo\n",
    "Demo running ${model} on Google Colab"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "# Install required packages\n",
    "!pip install transformers torch"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "# Import và setup\n",
    "from transformers import pipeline\n",
    "\n",
    "# Load model (chạy mất 2-5 phút lần đầu)\n",
    "print('Loading model...')\n",
    "generator = pipeline('text-generation', model='${model}')\n",
    "print('Model loaded successfully!')"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "# Generate text\n",
    "def generate_text(prompt):\n",
    "    result = generator(prompt, max_length=50, do_sample=True)\n",
    "    return result[0]['generated_text']\n",
    "\n",
    "# Test\n",
    "prompt = \"Hello, I am\"\n",
    "result = generate_text(prompt)\n",
    "print(f\"Prompt: {prompt}\")\n",
    "print(f\"Generated: {result}\")"
   ]
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "Python 3",
   "language": "python",
   "name": "python3"
  },
  "language_info": {
   "codemirror_mode": {
    "name": "ipython",
    "version": 3
   },
   "file_extension": ".py",
   "mimetype": "text/x-python",
   "name": "python",
   "nbconvert_exporter": "python",
   "pygments_lexer": "ipython3",
   "version": "3.8.5"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 4
}
EOF
            echo -e "${GREEN}✅ Generated Google Colab file: colab_demo.ipynb${NC}"
            ;;
            
        "3") # Replicate
            cat > replicate_demo.py << 'EOF'
import replicate

# Run model
print("Running AI model on Replicate...")

output = replicate.run(
    "stability-ai/stable-diffusion:27b93a2413e7f36cd83da926f3656280b2931564ff050bf9575f1fdf9bcd7478",
    input={
        "prompt": "A beautiful sunset over mountains, highly detailed, 4k resolution",
        "num_outputs": 1,
        "num_inference_steps": 20
    }
)

print("Generated image URL:", output)

# Text generation alternative
# output = replicate.run(
#     "meta-llama/llama-2-7b-chat:02e509c789964a7ea8736978a43525956ef40497be5043afe0b88f131e36e2e1",
#     input={
#         "prompt": "Tell me about AI",
#         "max_length": 100
#     }
# )
EOF
            echo -e "${GREEN}✅ Generated Replicate file: replicate_demo.py${NC}"
            ;;
            
        "4") # Paperspace
            cat > gradient_demo.py << 'EOF'
# Paperspace Gradient Demo
# Install: pip install paperspace gradient
import gradient

# Login (set PAPERSPCE_API_KEY environment variable)
# export PAPERSPACE_API_KEY=your_api_key_here

def deploy_model():
    print("Deploying model on Paperspace Gradient...")
    
    # Create experiment
    experiment = gradient.experiments.create(
        name="ai-model-demo",
        project_id="your_project_id",
        machine_type="P4000",  # GPU type
        command="python your_script.py",
        workspace=".",
        entrypoint="python your_script.py"
    )
    
    print(f"Experiment created: {experiment.id}")

if __name__ == "__main__":
    deploy_model()
EOF
            echo -e "${GREEN}✅ Generated Paperspace file: gradient_demo.py${NC}"
            ;;
            
        "5") # Modal
            cat > modal_demo.py << 'EOF'
import modal

# Define the function
@modal.function(gpu="A10G")  # GPU type
def ai_model_inference():
    from transformers import pipeline
    import torch
    
    # Load model
    generator = pipeline('text-generation', model='gpt2')
    
    def run_inference(prompt):
        result = generator(prompt, max_length=50)
        return result[0]['generated_text']
    
    return run_inference

# Deploy
if __name__ == "__main__":
    # Install modal: pip install modal
    # Run: python -m modal deploy modal_demo.py
    print("Deploy to Modal with: python -m modal deploy modal_demo.py")
EOF
            echo -e "${GREEN}✅ Generated Modal file: modal_demo.py${NC}"
            ;;
    esac
}

# Main menu
show_menu() {
    echo -e "\n${BLUE}🎯 Chọn nền tảng deployment:${NC}"
    for i in {1..5}; do
        echo -e "${GREEN}$i.${NC} ${platforms[$i]}"
    done
    echo -e "${YELLOW}q.${NC} Quit"
}

# Main script
main() {
    echo -e "${YELLOW}🔍 Tìm hiểu các platform miễn phí chạy AI models:${NC}"
    echo -e "${BLUE}Platform Count:${NC} ${#platforms[@]} options available"
    
    while true; do
        show_menu
        
        read -p "Enter your choice (1-5, q to quit): " choice
        
        case $choice in
            [1-5])
                show_platform_info $choice
                
                read -p "Generate deployment code? (y/n): " generate
                if [[ $generate == "y" || $generate == "Y" ]]; then
                    echo -e "${YELLOW}🔧 Generating deployment code...${NC}"
                    generate_deployment_code $choice "${recommended_models[$choice]}"
                    
                    echo -e "\n${BLUE}📋 Next Steps:${NC}"
                    case $choice in
                        1) # Hugging Face
                            echo "1. Sign up at: ${signup_urls[$choice]}"
                            echo "2. Create new Space at https://huggingface.co/spaces"
                            echo "3. Upload generated files (app.py, requirements.txt)"
                            echo "4. Deploy automatically!"
                            ;;
                        2) # Google Colab
                            echo "1. Go to: ${signup_urls[$choice]}"
                            echo "2. Upload the generated colab_demo.ipynb"
                            echo "3. Enable GPU: Runtime > Change runtime type > GPU"
                            echo "4. Run cells sequentially"
                            ;;
                        3) # Replicate
                            echo "1. Sign up: ${signup_urls[$choice]}"
                            echo "2. Get API key from dashboard"
                            echo "3. Run: python replicate_demo.py"
                            echo "4. Or deploy via web interface"
                            ;;
                        4) # Paperspace
                            echo "1. Sign up: ${signup_urls[$choice]}"
                            echo "2. Get API key"
                            echo "3. Set environment: export PAPERSPACE_API_KEY=your_key"
                            echo "4. Run: python gradient_demo.py"
                            ;;
                        5) # Modal
                            echo "1. Sign up: ${signup_urls[$choice]}"
                            echo "2. Install: pip install modal"
                            echo "3. Deploy: python -m modal deploy modal_demo.py"
                            echo "4. Call function via generated endpoint"
                            ;;
                    esac
                fi
                ;;
            q|Q)
                echo -e "${GREEN}👋 Good luck with your AI deployment!${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}❌ Invalid choice. Please try again.${NC}"
                ;;
        esac
        
        echo
        read -p "Press Enter to continue..."
    done
}

# Help message
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Free AI Cloud Deployment Assistant"
    echo ""
    echo "Usage: $0 [options]"
    echo ""
    echo "This script helps you deploy AI models to various free cloud platforms:"
    echo "  ✅ Hugging Face Spaces - Unlimited public deployment"
    echo "  ✅ Google Colab - Free GPU access"
    echo "  ✅ Replicate - Serverless scaling"
    echo "  ✅ Paperspace Gradient - Professional MLOps"
    echo "  ✅ Modal - Powerful GPU options"
    echo ""
    echo "Features:"
    echo "  - Platform comparison and details"
    echo "  - Generated deployment code"
    echo "  - Step-by-step guides"
    echo "  - Model recommendations"
    echo ""
    echo "No external dependencies required!"
    exit 0
fi

# Run main function
main