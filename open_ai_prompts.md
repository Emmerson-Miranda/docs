# Prompts for AI

## Create prompts

1 - Create the prompt as best as you can
2 - Ask the AI: Act as prompt engineer, review the following prompt for me, optimize it to make it better, and ask me any question you have before proceed

**Prompt OpenAI**
```text
How can I build more effective prompts for OpenAI models? Provide a structured breakdown of key elements (such as context, role, constraints, etc.) with a brief explanation for each. Additionally, include best practices for improving prompt accuracy and reliability.
```

Answer about how to **Building More Effective Prompts for OpenAI Models**  

```text
1️⃣ **Context** – Provide background information relevant to the request. This helps the model generate responses that align with the situation or domain.  
2️⃣ **Role** – Assign a role to the model (e.g., "You are a cybersecurity expert"). This influences the tone, depth, and style of the response.  
3️⃣ **Task Definition** – Clearly state what you want the model to do. Be explicit in your instructions (e.g., "Summarize this text in two sentences").  
4️⃣ **Constraints & Format** – Define limits such as word count, response format (list, table, JSON), or specific guidelines (e.g., "Respond in under 100 words").  
5️⃣ **Examples & Demonstrations** – Providing sample inputs and expected outputs improves consistency and reduces ambiguity.  
6️⃣ **Tone & Style Guidance** – If needed, specify the tone (formal, casual, technical) to match your audience.  
7️⃣ **Step-by-Step Breakdown** – For complex tasks, ask the model to break down the process into logical steps.  
8️⃣ **Iteration & Refinement** – Testing and tweaking the prompt over multiple iterations improves response quality.  
```

### 🔹 Prompt Template for OpenAI Models
```
[Instruction]: Clearly state what you want the model to do.  
[Context]: Provide background information to guide the response.  
[Role]: Assign a role or persona to shape the model’s tone and expertise.  
[Format]: Specify the output format (list, table, JSON, paragraph, etc.).  
[Constraints]: Define limits such as word count, level of detail, or style.  
[Examples]: (Optional) Show input-output pairs to guide response consistency.  
```

Example
````
Instruction: Summarize the following article in a concise, easy-to-read format.  
Context: The article is about the impact of AI on the job market, discussing automation, job displacement, and new opportunities.  
Role: You are an expert tech journalist.  
Format: Provide a three-paragraph summary.  
Constraints: Use simple language that a general audience can understand. Keep each paragraph under 50 words.  
Examples: N/A  
```

### **🔹 Best Practices for Improving Accuracy & Reliability**  

✅ **Be Specific & Direct** – Avoid vague instructions. Precise prompts lead to better responses.  
✅ **Use System & User Messages (if applicable)** – In tools like the OpenAI API, separating system instructions from user queries improves results.  
✅ **Avoid Ambiguity** – Clearly define terms, especially in technical domains.  
✅ **Encourage Reasoning** – For complex tasks, request explanations or step-by-step reasoning.  
✅ **Limit Response Scope** – Prevent overly broad responses by setting boundaries (e.g., “Explain in three bullet points”).  
✅ **Test & Iterate** – Experiment with variations of your prompt to optimize performance.  


## Frameworks

### RACE

Role - Specify the role
Action - Mention action needed
Context - Provide background information
Explanation - Describe your outcome

### CARE

Context - 
Action - 
Result - Mention your goal
Example - Give some example outputs

### APE

Action - 
Purpose - Mention your goal
Execution - Describe the output you want

### ROSES

Role - 
Objective - Mention the result needed
Scenario - Provide background information
Expected solution - Describe outcome
Steps - Ask for steps for the outcome

### CREATE

Character - Specify the role    
Request - Define the job to be done
Examples - Give some example outputs
Adjustment - Provide betterment instructions
Type of output - Specify output format
Extras - Add more context

### COAST

Context - Provide background information
Objective - Mention the result needed (goal)
Actions - Explain all actions needed
Scenario - Mention the problem
Tasks - Mention job to be done

### TAG

Task - Define task
Action - Define the job to be done
Goal - Explain end goal

### PAIN

Problem - Describe the problem
Action - Mention the job to be done
Information - Ask for details
Next steps - Ask for resources

### RISE

Role - Mention/Specify the role
Input - Give context and instructions
Steps - Ask for stepwise output
Execution - Describe the output

### CREO

Context - Give background information
Request - Define the job to be done
Explanation - Explain the task
Outcome - Describe the output
