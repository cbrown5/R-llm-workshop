# Quality statistics with large language models

CJ Brown

Perspective article

Aim for environmental sciences journal, e.g. Methods in Ecology and Evolution or Environmental Modelling and Software

Aim for 2000-3000 words


## Abstract

Large language models (LLMs) are rapidly transforming scientific workflows, including statistical analyses in environmental sciences. While these AI tools offer impressive capabilities for code generation and analytical guidance, evaluations reveal significant limitations in their statistical reasoning. This perspective addresses the need for effective prompting guidelines to ensure quality statistical analyses when using LLMs. Drawing on empirical evaluations and practical experience, I provide a framework for environmental scientists to leverage these powerful tools while maintaining statistical rigor. Key recommendations include: separating workflows into components that align with LLM strengths and limitations; providing rich context through domain knowledge, data summaries, and research questions; using structured prompting techniques like Chain of Thought reasoning; and maintaining human oversight of critical statistical decisions. By understanding LLM capabilities and employing these prompting strategies, researchers can harness these technologies to improve rather than compromise statistical quality in environmental research. Future research should focus on evaluations of LLMs for  statistical recommendations, development of specialized prompting strategies, and integration of LLMs with traditional statistical approaches.

## Introduction

Large language models (LLMs) are rapidly transforming scientific workflows across disciplines, including environmental sciences. These AI tools offer unprecedented capabilities in generating code, analyzing data, and providing statistical guidance. Recent surveys indicate that over XXX% of researchers now incorporate LLMs into their workflows, with applications ranging from literature reviews to complex statistical analyses (reference). While LLMs present opportunities to enhance research efficiency and quality, they also introduce new challenges for maintaining statistical rigor in scientific work.

The quality of statistical analyses in environmental sciences has long been a concern. Reviews have identified persistent issues including inappropriate model selection, inadequate consideration of assumptions, and improper interpretation of results (refs e.g. Zuur ; Forstmeier). These challenges are particularly acute in environmental sciences, where complex ecological data often violate standard statistical assumptions and require specialized analytical approaches.

Recent evaluations of LLM performance in statistical tasks have revealed a concerning pattern: while these models excel at many tasks, their statistical recommendations often fall short of expert quality. Evaluations of several models, including GPT-4, found accuracy at suggesting correct statistical tests ranging from just 8% to 90% depending on the complexity of the statistical question (-ref). LLMs performed well on descriptive statistics (up to 90% accuracy) but struggled with inferential tests, particularly for complex designs requiring contingency tables (20-43% accuracy).

This "jagged frontier" of LLM capabilities—where performance varies dramatically across tasks—creates a situation where users may overestimate LLM reliability for statistical guidance. However, these same evaluations revealed that appropriate prompting strategies could significantly improve LLM performance, in some cases doubling accuracy rates.

This perspective article addresses the need for effective prompting guidelines to ensure quality statistical analyses when using LLMs. Drawing on empirical evaluations and practical experience, I provide a framework for environmental scientists to leverage these powerful tools while maintaining statistical rigor. By understanding LLM capabilities and limitations and employing structured prompting strategies, researchers can harness these technologies to improve rather than compromise statistical quality in environmental research.

## Current Status of Quality Statistics in Environmental Sciences

Statistical practices in environmental sciences have long faced scrutiny. Reviews across ecological and environmental journals have consistently identified concerning patterns in statistical implementation and reporting. See Brown et al. 2011
https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0200303
https://besjournals.onlinelibrary.wiley.com/doi/10.1111/j.2041-210X.2009.00001.x
https://pubmed.ncbi.nlm.nih.gov/27879038/

These challenges stem from several factors unique to environmental research. Environmental data often exhibit complex spatial and temporal dependencies, zero-inflation, overdispersion, and non-linear relationships that violate assumptions of standard statistical methods. Additionally, environmental scientists frequently come from diverse disciplinary backgrounds with varying levels of statistical training.

The rise of increasingly sophisticated statistical methods—from generalized linear mixed models to Bayesian approaches—has improved analytical capabilities but also widened the gap between statistical best practices and typical implementation. This gap creates a situation where environmental scientists may turn to LLMs for guidance without fully understanding the limitations of these AI systems in statistical contexts.

Recent meta-analyses of statistical practices in environmental journals indicate some improvement in basic statistical reporting but persistent issues with more complex analyses. ref to consider - https://www.tandfonline.com/doi/full/10.1080/00031305.2019.1583913


As LLMs become increasingly integrated into research workflows, there is both opportunity and risk. Without proper guidance, researchers may uncritically implement LLM-suggested analyses that perpetuate or even amplify existing problems. However, with appropriate prompting strategies, LLMs could potentially help address the statistical quality gap by providing more consistent, transparent, and rigorous analytical approaches.

## Opportunity for LLMs to Improve Statistics, If Used Correctly

Large language models present significant opportunities to enhance statistical practice in environmental sciences when used with appropriate guidance and oversight. These AI tools can democratize access to statistical expertise, providing researchers who lack ready access to statistical collaborators with guidance on appropriate methods and implementation strategies. This democratization is particularly valuable in resource-constrained settings or for early-career researchers still developing their statistical networks. For example, researchers in remote field stations or from institutions without dedicated statistical support can leverage LLMs to explore analytical options that might otherwise be inaccessible.

The code generation capabilities of LLMs represent another substantial benefit for statistical practice. These models excel at producing clean, well-documented code that follows contemporary best practices in programming and data analysis. When properly prompted, LLMs can generate R or Python scripts with comprehensive comments, logical structure, and adherence to style guides—potentially improving computational reproducibility across environmental sciences. This advantage addresses a persistent challenge in the field, where poorly documented or inconsistently structured code has hampered reproducibility efforts.

LLMs also facilitate rapid exploration of alternative analytical approaches, enabling researchers to quickly generate and compare multiple statistical strategies. This capability encourages more robust sensitivity analyses, as researchers can efficiently implement various models to assess how analytical choices influence results. For instance, an ecologist studying species distributions could use an LLM to implement both frequentist and Bayesian approaches to the same question, comparing outcomes and assumptions without investing extensive time in coding each approach from scratch.

Documentation and transparency—critical elements of rigorous science—can be substantially improved through LLM assistance. These tools can help generate detailed methodological descriptions, create reproducible workflows with appropriate documentation, and ensure consistent reporting of statistical procedures. By prompting LLMs to document analytical decisions and assumptions explicitly, researchers can enhance the transparency of their statistical workflows, making them more accessible to reviewers and future researchers seeking to build upon their work.

Beyond implementation benefits, LLMs offer valuable opportunities for statistical learning and skill development. When used as interactive tutors rather than black-box solution providers, these models can enhance researchers' statistical understanding by explaining concepts, suggesting relevant literature, and demonstrating proper implementation techniques. This educational function is particularly valuable in environmental sciences, where researchers often come from diverse disciplinary backgrounds with varying levels of statistical training. By engaging with LLMs through carefully structured prompts that request explanations and justifications, researchers can develop deeper statistical intuition alongside practical implementation skills.

However, realizing these benefits requires understanding the fundamental nature of LLMs and their limitations. Unlike traditional statistical software that implements specific algorithms, LLMs generate responses based on patterns learned from training data. This distinction is crucial—LLMs do not "understand" statistics in the way human experts do, but rather predict what text would likely follow in a statistical context. The implications of this prediction-based approach are significant for statistical practice, as these models may confidently suggest inappropriate methods, fail to recognize violations of statistical assumptions, or generate plausible-sounding but incorrect interpretations. 

A further risk of accelerating statistical computation is the opportunities it creates for p-hacking. Researchers can write code to explore 10s or 100s of alternatives for solving a statistical issue, creating further opportunities for 

The challenge, therefore, is to develop prompting strategies that maximize LLMs' strengths while compensating for their weaknesses. Effective prompting requires providing sufficient context about research questions, data characteristics, and analytical constraints to guide the model toward appropriate statistical recommendations. It also involves maintaining critical oversight of model outputs, particularly for decisions requiring deeper statistical understanding such as assumption checking and result interpretation.

The opportunity lies in developing a new kind of statistical workflow that combines human expertise with LLM capabilities. In this workflow, researchers maintain responsibility for critical statistical decisions while using LLMs to implement analyses efficiently, explore options, and enhance documentation. This human-AI partnership represents a middle path between complete automation and traditional manual implementation—leveraging the efficiency and consistency of LLMs while preserving the critical judgment and domain expertise of human researchers. The key to this workflow is effective prompting—providing LLMs with the context, constraints, and guidance needed to generate high-quality statistical advice and code that advances rather than compromises statistical rigor in environmental research.

## LLM Overview

To develop effective prompting strategies, it's essential to understand how LLMs function. At their core, LLMs are prediction engines that generate text one token at a time based on patterns learned during training. A token is roughly equivalent to a word part, a word, or a common phrase.

This token-by-token prediction process has important implications for statistical guidance. LLMs don't reason about statistics from first principles; they predict what text would likely follow in a statistical context based on their training data. This means their statistical advice reflects patterns in existing literature and code—including both best practices and common mistakes.

Several key parameters influence LLM behavior:

1. **Temperature**: Controls randomness in token prediction. Lower temperatures (closer to 0) make responses more deterministic and conservative, while higher temperatures (closer to 2) increase creativity but potentially reduce reliability. For statistical applications, lower temperatures typically produce more consistent and conventional recommendations.

2. **Context window**: The amount of text an LLM can consider when generating a response. Modern LLMs have context windows ranging from 100,000 to 1,000,000 tokens. Larger context windows allow for including more detailed information about data, research questions, and statistical requirements.

3. **Model complexity**: Different models have varying capabilities based on their size, training data, and architecture. More complex models (e.g., Claude-3.7-Sonnet vs. Claude-3.5-Haiku) generally provide more nuanced statistical guidance but at higher computational and financial cost.

4. **System prompt**: Sets the overall context and constraints for the LLM. This "behind-the-scenes" instruction shapes how the model responds to user queries and can significantly impact statistical advice quality.

Understanding these parameters allows researchers to optimize LLM interactions for statistical applications. For example, using lower temperatures for statistical recommendations increases consistency, while larger context windows enable including more detailed information about data characteristics and research questions.

The distinction between different types of LLM interfaces is also important. Basic chat interfaces (like ChatGPT) provide limited control over these parameters, while API access and specialized coding assistants (like GitHub Copilot) offer more customization options. For statistical applications, interfaces that allow inclusion of data summaries, code context, and specialized system prompts will produce better results.

## Prompting Guidelines Best Practices

Effective prompting can dramatically improve the quality of statistical guidance from LLMs. Based on empirical evaluations and practical experience, the following guidelines provide a framework for environmental scientists seeking to leverage LLMs for statistical applications.

### Recognizing Different Steps in Workflows

A critical first step is separating statistical workflows into distinct components that align with LLM strengths and limitations:

1. **Statistical approach selection**: Determining appropriate statistical methods for research questions
2. **Implementation planning**: Designing the analytical workflow and code structure
3. **Code generation**: Writing the actual code to implement analyses
4. **Interpretation guidance**: Understanding and reporting results

LLMs perform differently across these components. They excel at code generation and implementation planning but are less reliable for selecting appropriate statistical approaches or interpreting complex results. This uneven performance profile suggests a workflow where:

- Researchers maintain primary responsibility for statistical approach selection, potentially using LLMs to explore options but validating choices against literature and expert knowledge
- LLMs take a more central role in implementation planning and code generation, with researchers providing clear constraints on the workflow
- Interpretation remains a collaborative process where LLMs can suggest standard interpretations but researchers critically evaluate these suggestions

This separation of responsibilities helps prevent overreliance on LLMs for decisions that require deeper statistical understanding while leveraging their strengths in code generation and documentation.

### Statistical Advice

When seeking statistical guidance from LLMs, several prompting strategies can significantly improve response quality:

1. **Include domain knowledge**: Attach relevant literature, guidelines, or textbook excerpts to prompts. For example:

```
How can I statistically test the relationship between pres.topa and CB_cover? 
pres.topa is count data representing fish abundance. Use @websearch to find 
robust recommendations for ecologists to analyze count data before proceeding 
with your recommendations.
```

2. **Provide data context**: Always include information about data types, distributions, and structure:

```
I need to analyze the relationship between fish abundance (integer counts, 
zero-inflated) and coral cover (continuous percentage). Sites are spatially 
clustered within regions. What statistical approaches would be appropriate?
```

3. **Attach actual data**: Include data summaries, head() output, or small datasets directly in prompts:

```
How can I statistically test the relationship between pres.topa and CB_cover? 
Here are the first 6 rows of data:
[data table]
```

4. **Use Chain of Thought reasoning**: Explicitly request step-by-step reasoning:

```
Using Chain of Thought reasoning, what statistical approach would be most 
appropriate for analyzing the relationship between fish abundance (count data) 
and coral cover (continuous)?
```

However, CoT is not effective at improving statistical advice on its own. It needsd to be combined with other approaches, particuarly domain knowledge and attaching data. 

5. **Request self-evaluation**: Ask the LLM to evaluate its own recommendations:

```
Great. Evaluate the robustness of each suggestion on a 1-10 scale and explain 
the strengths and limitations of each approach.
```

6. **Compare multiple approaches**: Request alternative methods and comparisons:

```
What are three different statistical approaches I could use for this analysis? 
For each, explain the assumptions, advantages, and limitations.
```

These strategies have been shown to significantly improve the quality of statistical guidance. For example, including data context and domain knowledge increased accuracy in statistical test selection from 43% to 78% in one evaluation (ref).

### Code Implementation Advice

For implementing statistical analyses in R, different prompting strategies apply:

1. **Create a detailed project README**: Document the project context, research questions, data structure, and analytical approach in a README.md file that can be attached to prompts:

```
Help me plan R code to implement this analysis based on the project context 
in the README.
```

2. **Use a two-step approach**: First plan the analysis structure, then implement specific components:

```
First, outline the overall workflow for analyzing the relationship between 
fish abundance and coral cover using a negative binomial GLM. Then, we'll 
implement each step.
```

3. **Provide implementation constraints**: Specify packages, coding style, and other requirements:

```
Implement this analysis using the tidyverse ecosystem and INLA for Bayesian 
modeling. Follow tidyverse style guidelines and prioritize code readability.
```

4. **Request modular code**: Ask for code organized into logical functions and scripts:

```
Create modular scripts for this analysis with separate files for data 
preparation, model fitting, diagnostics, and visualization.
```

5. **Include verification steps**: Request code that validates assumptions and checks model fit:

```
Include diagnostic checks for overdispersion, zero-inflation, and spatial 
autocorrelation in the model implementation.
```

6. **Iteratively refine**: Start with a basic implementation and progressively add complexity:

```
Let's start with a simple negative binomial GLM for fish abundance. Once 
that's working, we'll extend it to account for spatial clustering.
```

These strategies help ensure that LLM-generated code is not only syntactically correct but also statistically appropriate and well-structured. By providing clear constraints and expectations, researchers can guide LLMs toward implementations that follow best practices in both programming and statistical analysis.

## Discussion and Conclusion

Large language models represent both opportunity and challenge for statistical practice in environmental sciences. When used thoughtfully with effective prompting strategies, they can enhance analytical workflows, improve code quality, and potentially address longstanding issues in statistical implementation. However, uncritical reliance on LLMs risks perpetuating or even amplifying existing problems in statistical practice.

The prompting guidelines presented in this perspective provide a framework for leveraging LLMs while maintaining statistical rigor. By separating workflows into components that align with LLM strengths and limitations, providing appropriate context and constraints, and maintaining human oversight of critical decisions, researchers can harness these powerful tools while mitigating their risks.

Several key principles emerge from this analysis:

1. **Maintain critical thinking**: LLMs should complement rather than replace statistical expertise. Researchers must critically evaluate LLM suggestions against domain knowledge and statistical principles.

2. **Provide rich context**: The quality of LLM statistical guidance improves dramatically when provided with detailed information about research questions, data characteristics, and analytical constraints.

3. **Leverage strengths, compensate for weaknesses**: Use LLMs primarily for tasks where they excel (code generation, implementation planning) while maintaining human oversight of tasks requiring deeper statistical understanding (method selection, assumption checking, interpretation).

4. **Document LLM use**: Transparency about LLM use in research workflows is essential for reproducibility and evaluation. Publications should clearly describe how LLMs were used and what prompting strategies were employed.

5. **Develop LLM literacy**: As these tools become increasingly integrated into research workflows, developing "LLM literacy"—understanding how these models work, their limitations, and effective interaction strategies—becomes an essential skill for environmental scientists.

The rapid evolution of LLM capabilities suggests that their role in statistical workflows will only increase. Current models already show impressive performance in code generation and implementation planning, and future models may address some of the limitations identified in statistical reasoning. However, the fundamental nature of LLMs as prediction engines rather than reasoning systems means that human oversight will remain essential for ensuring statistical quality.

### Research Needs

Several critical research needs emerge from this analysis:

1. **Evaluations of LLM statistical performance**: Systematic assessments across diverse environmental data types and analytical challenges would help identify specific strengths and weaknesses.

2. **Development of specialized prompting strategies**: Domain-specific prompting templates and guidelines could improve consistency and quality of statistical implementations.

3. **Integration of LLMs with traditional statistical software**: Hybrid systems that combine LLM flexibility with the algorithmic reliability of traditional statistical packages could leverage the strengths of both approaches.

4. **Educational approaches for LLM-assisted statistics**: New pedagogical strategies are needed to develop statistical understanding in an era where code implementation is increasingly automated.

5. **Ethical frameworks for LLM use in research**: Guidelines for appropriate attribution, transparency, and responsibility when using LLM-assisted analyses in published research.

By addressing these research needs and adopting thoughtful prompting strategies, environmental scientists can harness the power of large language models to enhance rather than compromise statistical quality. The future of environmental statistics likely lies not in choosing between human expertise and artificial intelligence, but in developing effective partnerships that leverage the unique strengths of each.