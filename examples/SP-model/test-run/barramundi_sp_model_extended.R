# Extended Surplus Production Model for Barramundi in the Gulf of Carpentaria
# -------------------------------------------------------------------------

# Load required libraries
library(ggplot2)
library(dplyr)
library(reshape2)

# Read the data
barra_data <- read.csv("Data for Barramundi model.csv")

# Examine the data structure
str(barra_data)
summary(barra_data)

# Calculate CPUE (Catch per Unit Effort)
barra_data$cpue <- barra_data$Barramundicatch / barra_data$Effort

# Remove rows with missing CPUE values
barra_data <- barra_data[!is.na(barra_data$cpue), ]

# Plot the time series of catch, effort, and CPUE
par(mfrow=c(3,1))
plot(barra_data$Year, barra_data$Barramundicatch, type="l", 
     xlab="Year", ylab="Catch (t)", main="Barramundi Catch")
points(barra_data$Year, barra_data$Barramundicatch, pch=16)
plot(barra_data$Year, barra_data$Effort, type="l", 
     xlab="Year", ylab="Effort", main="Fishing Effort")
points(barra_data$Year, barra_data$Effort, pch=16)
plot(barra_data$Year, barra_data$cpue, type="l", 
     xlab="Year", ylab="CPUE", main="Catch Per Unit Effort")
points(barra_data$Year, barra_data$cpue, pch=16)
par(mfrow=c(1,1))

# Check for relationship between CPUE and catch (to assess data contrast)
plot(barra_data$Barramundicatch, barra_data$cpue, 
     xlab="Catch", ylab="CPUE", main="CPUE vs Catch")
abline(lm(cpue ~ Barramundicatch, data=barra_data), col="red")

# Cross-correlation analysis between CPUE and catch
ccf_result <- ccf(barra_data$Barramundicatch, barra_data$cpue, 
                 main="Cross-correlation between Catch and CPUE")

# Examine environmental variables
if(sum(!is.na(barra_data$inundation)) > 0) {
  par(mfrow=c(3,1), mar=c(4,4,2,1))
  plot(barra_data$Year, barra_data$inundation, type="l", 
       xlab="Year", ylab="Inundation", main="Inundation")
  points(barra_data$Year, barra_data$inundation, pch=16)
  
  plot(barra_data$Year, barra_data$Streamflow, type="l", 
       xlab="Year", ylab="Streamflow", main="Streamflow")
  points(barra_data$Year, barra_data$Streamflow, pch=16)
  
  plot(barra_data$Year, barra_data$Streamflow_wetseason, type="l", 
       xlab="Year", ylab="Wet Season Streamflow", main="Wet Season Streamflow")
  points(barra_data$Year, barra_data$Streamflow_wetseason, pch=16)
  par(mfrow=c(1,1))
  
  # Check correlations with CPUE
  env_vars <- c("inundation", "Streamflow", "Streamflow_wetseason", "NDVI", "pasture_bio")
  env_cors <- sapply(env_vars, function(var) {
    if(sum(!is.na(barra_data[[var]])) > 0) {
      cor(barra_data$cpue, barra_data[[var]], use="pairwise.complete.obs")
    } else {
      NA
    }
  })
  print(env_cors)
}

# Define the Surplus Production Model functions
# --------------------------------------------

# 1. Schaefer Model
schaefer_model <- function(params, data) {
  # Parameters
  r <- params[1]      # Intrinsic growth rate
  K <- params[2]      # Carrying capacity
  q <- params[3]      # Catchability coefficient
  B_init <- params[4] # Initial biomass
  
  # Initialize vectors
  n <- nrow(data)
  B <- numeric(n+1)
  B[1] <- B_init
  
  # Calculate predicted biomass and CPUE
  pred_cpue <- numeric(n)
  
  for (i in 1:n) {
    # Biomass dynamics: B(t+1) = B(t) + r*B(t)*(1-B(t)/K) - Catch(t)
    B[i+1] <- B[i] + r*B[i]*(1-B[i]/K) - data$Barramundicatch[i]
    
    # Ensure biomass doesn't go negative
    if (B[i+1] < 0) B[i+1] <- 0.01
    
    # Predicted CPUE: q*B(t)
    pred_cpue[i] <- q * B[i]
  }
  
  # Calculate negative log-likelihood (assuming log-normal error)
  obs_cpue <- data$cpue
  sigma <- sd(log(obs_cpue) - log(pred_cpue), na.rm=TRUE)
  nll <- sum(log(sigma) + 0.5 * ((log(obs_cpue) - log(pred_cpue))/sigma)^2, na.rm=TRUE)
  
  # Return results
  list(
    nll = nll,
    biomass = B,
    pred_cpue = pred_cpue,
    sigma = sigma
  )
}

# 2. Fox Model (modified Pella-Tomlinson with p approaching 0)
fox_model <- function(params, data) {
  # Parameters
  r <- params[1]      # Intrinsic growth rate
  K <- params[2]      # Carrying capacity
  q <- params[3]      # Catchability coefficient
  B_init <- params[4] # Initial biomass
  
  # Initialize vectors
  n <- nrow(data)
  B <- numeric(n+1)
  B[1] <- B_init
  
  # Calculate predicted biomass and CPUE
  pred_cpue <- numeric(n)
  
  # Small value for p to approximate Fox model
  p <- 1e-08
  
  for (i in 1:n) {
    # Fox model dynamics: B(t+1) = B(t) + r*B(t)*(1-log(B(t))/log(K)) - Catch(t)
    # Using the Polacheck et al. (1993) formulation: B(t+1) = B(t) + (r*B(t)/p)*(1-(B(t)/K)^p) - Catch(t)
    B[i+1] <- B[i] + (r*B[i]/p)*(1-(B[i]/K)^p) - data$Barramundicatch[i]
    
    # Ensure biomass doesn't go negative
    if (B[i+1] < 0) B[i+1] <- 0.01
    
    # Predicted CPUE: q*B(t)
    pred_cpue[i] <- q * B[i]
  }
  
  # Calculate negative log-likelihood (assuming log-normal error)
  obs_cpue <- data$cpue
  sigma <- sd(log(obs_cpue) - log(pred_cpue), na.rm=TRUE)
  nll <- sum(log(sigma) + 0.5 * ((log(obs_cpue) - log(pred_cpue))/sigma)^2, na.rm=TRUE)
  
  # Return results
  list(
    nll = nll,
    biomass = B,
    pred_cpue = pred_cpue,
    sigma = sigma
  )
}

# Objective functions for optimization
schaefer_objective <- function(params, data) {
  model_output <- schaefer_model(params, data)
  return(model_output$nll)
}

fox_objective <- function(params, data) {
  model_output <- fox_model(params, data)
  return(model_output$nll)
}

# Initial parameter values
init_params <- c(
  r = 0.3,        # Intrinsic growth rate
  K = 10000,       # Carrying capacity
  q = 0.05,        # Catchability coefficient
  B_init = 1000    # Initial biomass
)

# Set lower and upper bounds for parameters
lower_bounds <- c(0.01, 100, 0.001, 1)
upper_bounds <- c(1.0, 20000, 1.0, 5000)

# Fit both models using optimization
schaefer_fit <- optim(
  par = init_params,
  fn = schaefer_objective,
  data = barra_data,
  method = "L-BFGS-B",
  lower = lower_bounds,
  upper = upper_bounds,
  control = list(maxit = 1000)
)

schaefer_fit

schaefer_output <- schaefer_model(schaefer_params, barra_data)
plot(schaefer_output$pred_cpue)


fox_fit <- optim(
  par = init_params,
  fn = fox_objective,
  data = barra_data,
  method = "L-BFGS-B",
  lower = lower_bounds,
  upper = upper_bounds,
  control = list(maxit = 1000)
)

# Extract the best-fit parameters
schaefer_params <- schaefer_fit$par
names(schaefer_params) <- c("r", "K", "q", "B_init")

fox_params <- fox_fit$par
names(fox_params) <- c("r", "K", "q", "B_init")

# Calculate model outputs with best parameters

fox_output <- fox_model(fox_params, barra_data)

# Calculate MSY and related reference points for Schaefer model
schaefer_MSY <- (schaefer_params["r"] * schaefer_params["K"]) / 4
schaefer_B_MSY <- schaefer_params["K"] / 2
schaefer_F_MSY <- schaefer_params["r"] / 2
schaefer_E_MSY <- schaefer_F_MSY / schaefer_params["q"]

# Calculate MSY and related reference points for Fox model
p <- 1e-08  # Small value for p to approximate Fox model
fox_MSY <- (fox_params["r"] * fox_params["K"]) / ((p + 1)^((p + 1)/p))
fox_B_MSY <- fox_params["K"] / exp(1)  # Approximately 0.368*K
fox_F_MSY <- fox_params["r"] / (p + 1)
fox_E_MSY <- fox_F_MSY / fox_params["q"]

# Compare model fits using AIC
schaefer_AIC <- 2 * schaefer_fit$value + 2 * length(schaefer_params)
fox_AIC <- 2 * fox_fit$value + 2 * length(fox_params)

# Print comparison of model fits
cat("\nModel Comparison:\n")
cat("Schaefer model negative log-likelihood:", round(schaefer_fit$value, 2), "\n")
cat("Fox model negative log-likelihood:", round(fox_fit$value, 2), "\n")
cat("Schaefer model AIC:", round(schaefer_AIC, 2), "\n")
cat("Fox model AIC:", round(fox_AIC, 2), "\n")
cat("Preferred model:", ifelse(schaefer_AIC < fox_AIC, "Schaefer", "Fox"), "\n\n")

# Print key fishery parameters for both models
cat("Schaefer Model Parameters:\n")
cat("Intrinsic growth rate (r):", round(schaefer_params["r"], 4), "\n")
cat("Carrying capacity (K):", round(schaefer_params["K"], 0), "tonnes\n")
cat("Catchability coefficient (q):", round(schaefer_params["q"], 6), "\n")
cat("Initial biomass (B_init):", round(schaefer_params["B_init"], 0), "tonnes\n")
cat("Maximum Sustainable Yield (MSY):", round(schaefer_MSY, 0), "tonnes\n")
cat("Biomass at MSY (B_MSY):", round(schaefer_B_MSY, 0), "tonnes\n")
cat("Fishing mortality at MSY (F_MSY):", round(schaefer_F_MSY, 4), "\n")
cat("Effort at MSY (E_MSY):", round(schaefer_E_MSY, 0), "units\n")
cat("Current biomass (B_current):", round(schaefer_output$biomass[length(schaefer_output$biomass)], 0), "tonnes\n")
cat("Current depletion (B_current/K):", round(schaefer_output$biomass[length(schaefer_output$biomass)]/schaefer_params["K"], 2), "\n\n")

cat("Fox Model Parameters:\n")
cat("Intrinsic growth rate (r):", round(fox_params["r"], 4), "\n")
cat("Carrying capacity (K):", round(fox_params["K"], 0), "tonnes\n")
cat("Catchability coefficient (q):", round(fox_params["q"], 6), "\n")
cat("Initial biomass (B_init):", round(fox_params["B_init"], 0), "tonnes\n")
cat("Maximum Sustainable Yield (MSY):", round(fox_MSY, 0), "tonnes\n")
cat("Biomass at MSY (B_MSY):", round(fox_B_MSY, 0), "tonnes\n")
cat("Fishing mortality at MSY (F_MSY):", round(fox_F_MSY, 4), "\n")
cat("Effort at MSY (E_MSY):", round(fox_E_MSY, 0), "units\n")
cat("Current biomass (B_current):", round(fox_output$biomass[length(fox_output$biomass)], 0), "tonnes\n")
cat("Current depletion (B_current/K):", round(fox_output$biomass[length(fox_output$biomass)]/fox_params["K"], 2), "\n\n")

# Plot model fits
years <- barra_data$Year
plot_years <- c(min(years):max(years))

# Plot observed vs predicted CPUE for both models
par(mfrow=c(2,1), mar=c(4,4,2,1))
# Schaefer model
plot(years, barra_data$cpue, type="p", pch=16, 
     xlab="Year", ylab="CPUE", main="Schaefer Model: Observed vs Predicted CPUE")
lines(years, schaefer_output$pred_cpue, col="red", lwd=2)
legend("topright", legend=c("Observed", "Predicted"), 
       pch=c(16, NA), lty=c(NA, 1), col=c("black", "red"))

# Fox model
plot(years, barra_data$cpue, type="p", pch=16, 
     xlab="Year", ylab="CPUE", main="Fox Model: Observed vs Predicted CPUE")
lines(years, fox_output$pred_cpue, col="blue", lwd=2)
legend("topright", legend=c("Observed", "Predicted"), 
       pch=c(16, NA), lty=c(NA, 1), col=c("black", "blue"))
par(mfrow=c(1,1))

# Plot estimated biomass trajectories for both models
plot(plot_years, schaefer_output$biomass, type="l", lwd=2, col="red",
     xlab="Year", ylab="Biomass (tonnes)", main="Estimated Biomass Trajectories")
lines(plot_years, fox_output$biomass, lwd=2, col="blue")
abline(h=schaefer_B_MSY, col="red", lty=2)
abline(h=fox_B_MSY, col="blue", lty=2)
abline(h=0.2*schaefer_params["K"], col="red", lty=3)
abline(h=0.2*fox_params["K"], col="blue", lty=3)
legend("topright", 
       legend=c("Schaefer Biomass", "Fox Biomass", 
                "Schaefer B_MSY", "Fox B_MSY",
                "Schaefer 0.2K", "Fox 0.2K"), 
       lty=c(1, 1, 2, 2, 3, 3), 
       col=c("red", "blue", "red", "blue", "red", "blue"))

# Plot phase plots (B/K vs Harvest Rate) for both models
par(mfrow=c(2,1), mar=c(4,4,2,1))

# Schaefer model
schaefer_harvest_rate <- barra_data$Barramundicatch / schaefer_output$biomass[1:length(years)]
schaefer_depletion <- schaefer_output$biomass[1:length(years)] / schaefer_params["K"]

plot(schaefer_depletion, schaefer_harvest_rate, type="p", pch=16,
     xlab="Biomass Depletion (B/K)", ylab="Harvest Rate (C/B)",
     main="Schaefer Model: Phase Plot", xlim=c(0, 1))
points(schaefer_depletion[length(schaefer_depletion)], 
       schaefer_harvest_rate[length(schaefer_harvest_rate)], 
       pch=16, col="red", cex=1.5)
abline(v=0.5, col="green", lty=2)  # B_MSY/K = 0.5 for Schaefer model
abline(v=0.2, col="red", lty=2)    # 0.2K limit reference point
abline(h=schaefer_F_MSY, col="blue", lty=2) # F_MSY reference
text(schaefer_depletion[length(schaefer_depletion)], 
     schaefer_harvest_rate[length(schaefer_harvest_rate)], 
     labels=paste("Current (", max(years), ")", sep=""), pos=4)

# Fox model
fox_harvest_rate <- barra_data$Barramundicatch / fox_output$biomass[1:length(years)]
fox_depletion <- fox_output$biomass[1:length(years)] / fox_params["K"]

plot(fox_depletion, fox_harvest_rate, type="p", pch=16,
     xlab="Biomass Depletion (B/K)", ylab="Harvest Rate (C/B)",
     main="Fox Model: Phase Plot", xlim=c(0, 1))
points(fox_depletion[length(fox_depletion)], 
       fox_harvest_rate[length(fox_harvest_rate)], 
       pch=16, col="red", cex=1.5)
abline(v=1/exp(1), col="green", lty=2)  # B_MSY/K ≈ 0.368 for Fox model
abline(v=0.2, col="red", lty=2)         # 0.2K limit reference point
abline(h=fox_F_MSY, col="blue", lty=2)  # F_MSY reference
text(fox_depletion[length(fox_depletion)], 
     fox_harvest_rate[length(fox_harvest_rate)], 
     labels=paste("Current (", max(years), ")", sep=""), pos=4)
par(mfrow=c(1,1))

# Perform projections for different harvest strategies
# --------------------------------------------------

# Function to project biomass forward for Schaefer model
project_schaefer <- function(B_start, r, K, annual_catch, years) {
  B <- numeric(years + 1)
  B[1] <- B_start
  
  for (i in 1:years) {
    B[i+1] <- B[i] + r*B[i]*(1-B[i]/K) - annual_catch
    if (B[i+1] < 0) B[i+1] <- 0.01
  }
  
  return(B)
}

# Function to project biomass forward for Fox model
project_fox <- function(B_start, r, K, annual_catch, years) {
  B <- numeric(years + 1)
  B[1] <- B_start
  p <- 1e-08  # Small value for p to approximate Fox model
  
  for (i in 1:years) {
    B[i+1] <- B[i] + (r*B[i]/p)*(1-(B[i]/K)^p) - annual_catch
    if (B[i+1] < 0) B[i+1] <- 0.01
  }
  
  return(B)
}

# Set up projection scenarios
# Use the preferred model based on AIC
preferred_model <- ifelse(schaefer_AIC < fox_AIC, "Schaefer", "Fox")

if (preferred_model == "Schaefer") {
  current_biomass <- schaefer_output$biomass[length(schaefer_output$biomass)]
  MSY <- schaefer_MSY
  B_MSY <- schaefer_B_MSY
  K <- schaefer_params["K"]
  r <- schaefer_params["r"]
  project_function <- project_schaefer
} else {
  current_biomass <- fox_output$biomass[length(fox_output$biomass)]
  MSY <- fox_MSY
  B_MSY <- fox_B_MSY
  K <- fox_params["K"]
  r <- fox_params["r"]
  project_function <- project_fox
}

projection_years <- 10
catch_scenarios <- c(0.8*MSY, MSY, 1.2*MSY)
names(catch_scenarios) <- c("80% of MSY", "MSY", "120% of MSY")

# Run projections
projections <- list()
for (i in 1:length(catch_scenarios)) {
  projections[[i]] <- project_function(
    current_biomass, 
    r, 
    K, 
    catch_scenarios[i], 
    projection_years
  )
}

# Plot projections
projection_years_axis <- max(years):(max(years) + projection_years)
if (preferred_model == "Schaefer") {
  plot(plot_years, schaefer_output$biomass, type="l", lwd=2,
       xlim=c(min(years), max(years) + projection_years),
       xlab="Year", ylab="Biomass (tonnes)", 
       main=paste(preferred_model, "Model: Biomass Projections Under Different Harvest Strategies"))
} else {
  plot(plot_years, fox_output$biomass, type="l", lwd=2,
       xlim=c(min(years), max(years) + projection_years),
       xlab="Year", ylab="Biomass (tonnes)", 
       main=paste(preferred_model, "Model: Biomass Projections Under Different Harvest Strategies"))
}

abline(v=max(years), col="gray", lty=2)
abline(h=B_MSY, col="green", lty=2)
abline(h=0.2*K, col="red", lty=2)

colors <- c("blue", "black", "red")
for (i in 1:length(projections)) {
  lines(projection_years_axis, projections[[i]], col=colors[i], lwd=2)
}

legend("topright", 
       legend=c("Historical", names(catch_scenarios), "B_MSY", "0.2K (Limit)"), 
       lty=c(1, rep(1, length(catch_scenarios)), 2, 2), 
       col=c("black", colors, "green", "red"))

# Perform bootstrap to estimate uncertainty in parameters
# -----------------------------------------------------

n_bootstrap <- 100  # Number of bootstrap samples

# Function to generate bootstrap samples for the preferred model
bootstrap_samples <- function(data, model_output, model_function, objective_function, params, n_samples) {
  # Extract residuals (log scale)
  log_residuals <- log(data$cpue) - log(model_output$pred_cpue)
  
  # Generate bootstrap samples
  bootstrap_results <- list()
  
  for (i in 1:n_samples) {
    # Resample residuals with replacement
    resampled_residuals <- sample(log_residuals, length(log_residuals), replace=TRUE)
    
    # Create bootstrap CPUE data
    bootstrap_cpue <- exp(log(model_output$pred_cpue) + resampled_residuals)
    
    # Create bootstrap dataset
    bootstrap_data <- data
    bootstrap_data$cpue <- bootstrap_cpue
    
    # Fit model to bootstrap data
    bootstrap_fit <- try(optim(
      par = params,
      fn = objective_function,
      data = bootstrap_data,
      method = "L-BFGS-B",
      lower = lower_bounds,
      upper = upper_bounds,
      control = list(maxit = 500)
    ), silent = TRUE)
    
    # Store results if optimization succeeded
    if (!inherits(bootstrap_fit, "try-error")) {
      bootstrap_results[[i]] <- bootstrap_fit$par
    }
  }
  
  # Convert to matrix
  result_matrix <- do.call(rbind, bootstrap_results)
  colnames(result_matrix) <- c("r", "K", "q", "B_init")
  
  return(result_matrix)
}

# Run bootstrap for the preferred model
if (preferred_model == "Schaefer") {
  bootstrap_results <- bootstrap_samples(
    barra_data, 
    schaefer_output, 
    schaefer_model, 
    schaefer_objective, 
    schaefer_params, 
    n_bootstrap
  )
} else {
  bootstrap_results <- bootstrap_samples(
    barra_data, 
    fox_output, 
    fox_model, 
    fox_objective, 
    fox_params, 
    n_bootstrap
  )
}

# Calculate confidence intervals for parameters
ci_results <- apply(bootstrap_results, 2, quantile, probs=c(0.025, 0.5, 0.975))
print(ci_results)

# Calculate MSY for each bootstrap sample
if (preferred_model == "Schaefer") {
  bootstrap_MSY <- (bootstrap_results[,"r"] * bootstrap_results[,"K"]) / 4
} else {
  p <- 1e-08
  bootstrap_MSY <- (bootstrap_results[,"r"] * bootstrap_results[,"K"]) / ((p + 1)^((p + 1)/p))
}
MSY_ci <- quantile(bootstrap_MSY, probs=c(0.025, 0.5, 0.975))

cat("\nBootstrap Results for", preferred_model, "Model (95% Confidence Intervals):\n")
cat("MSY:", round(MSY_ci[2], 0), "tonnes (", 
    round(MSY_ci[1], 0), "-", round(MSY_ci[3], 0), ")\n", sep="")

# Plot histograms of bootstrap parameter estimates
par(mfrow=c(2,2))
hist(bootstrap_results[,"r"], main="r", xlab="Intrinsic Growth Rate")
if (preferred_model == "Schaefer") {
  abline(v=schaefer_params["r"], col="red", lwd=2)
} else {
  abline(v=fox_params["r"], col="red", lwd=2)
}

hist(bootstrap_results[,"K"], main="K", xlab="Carrying Capacity")
if (preferred_model == "Schaefer") {
  abline(v=schaefer_params["K"], col="red", lwd=2)
} else {
  abline(v=fox_params["K"], col="red", lwd=2)
}

hist(bootstrap_results[,"q"], main="q", xlab="Catchability")
if (preferred_model == "Schaefer") {
  abline(v=schaefer_params["q"], col="red", lwd=2)
} else {
  abline(v=fox_params["q"], col="red", lwd=2)
}

hist(bootstrap_MSY, main="MSY", xlab="Maximum Sustainable Yield")
abline(v=MSY, col="red", lwd=2)
par(mfrow=c(1,1))

# Save results
if (preferred_model == "Schaefer") {
  save(schaefer_params, schaefer_output, schaefer_MSY, schaefer_B_MSY, 
       schaefer_F_MSY, bootstrap_results, MSY_ci,
       file="barramundi_sp_model_results.RData")
} else {
  save(fox_params, fox_output, fox_MSY, fox_B_MSY, 
       fox_F_MSY, bootstrap_results, MSY_ci,
       file="barramundi_sp_model_results.RData")
}

# Create a summary report
cat("\nSurplus Production Model Results for Barramundi in the Gulf of Carpentaria\n")
cat("==================================================================\n\n")
cat("Preferred model:", preferred_model, "\n\n")

cat("Model fit statistics:\n")
if (preferred_model == "Schaefer") {
  cat("Negative log-likelihood:", round(schaefer_fit$value, 2), "\n")
  cat("AIC:", round(schaefer_AIC, 2), "\n")
  cat("Convergence code:", schaefer_fit$convergence, "\n\n")
} else {
  cat("Negative log-likelihood:", round(fox_fit$value, 2), "\n")
  cat("AIC:", round(fox_AIC, 2), "\n")
  cat("Convergence code:", fox_fit$convergence, "\n\n")
}

cat("Parameter estimates (with 95% confidence intervals):\n")
for (i in 1:4) {
  param_name <- colnames(ci_results)[i]
  cat(param_name, ":", round(ci_results[2,i], 4), " (", 
      round(ci_results[1,i], 4), "-", round(ci_results[3,i], 4), ")\n", sep="")
}

cat("\nReference points:\n")
cat("MSY:", round(MSY_ci[2], 0), "tonnes (", 
    round(MSY_ci[1], 0), "-", round(MSY_ci[3], 0), ")\n", sep="")
cat("B_MSY:", round(B_MSY, 0), "tonnes\n")
if (preferred_model == "Schaefer") {
  cat("F_MSY:", round(schaefer_F_MSY, 4), "\n")
  cat("E_MSY:", round(schaefer_E_MSY, 0), "units\n\n")
} else {
  cat("F_MSY:", round(fox_F_MSY, 4), "\n")
  cat("E_MSY:", round(fox_E_MSY, 0), "units\n\n")
}

cat("Current stock status:\n")
if (preferred_model == "Schaefer") {
  current_biomass <- schaefer_output$biomass[length(schaefer_output$biomass)]
  current_depletion <- current_biomass / schaefer_params["K"]
  current_harvest_rate <- schaefer_harvest_rate[length(schaefer_harvest_rate)]
  status_relative_to_MSY <- ifelse(current_biomass > schaefer_B_MSY, "Above", "Below")
} else {
  current_biomass <- fox_output$biomass[length(fox_output$biomass)]
  current_depletion <- current_biomass / fox_params["K"]
  current_harvest_rate <- fox_harvest_rate[length(fox_harvest_rate)]
  status_relative_to_MSY <- ifelse(current_biomass > fox_B_MSY, "Above", "Below")
}

cat("Current biomass:", round(current_biomass, 0), "tonnes\n")
cat("Depletion level (B/K):", round(current_depletion, 2), "\n")
cat("Current harvest rate:", round(current_harvest_rate, 4), "\n")
cat("Status relative to MSY:", status_relative_to_MSY, "B_MSY\n")

cat("\nManagement Advice:\n")
cat("Based on the", preferred_model, "model results, the following management advice is provided:\n")

if (current_depletion < 0.2) {
  cat("- The stock is currently below the limit reference point (0.2K).\n")
  cat("- Immediate reduction in fishing pressure is recommended to allow stock recovery.\n")
} else if (current_depletion < B_MSY/K) {
  cat("- The stock is currently below B_MSY but above the limit reference point.\n")
  cat("- A catch limit below MSY (e.g.,", round(0.8*MSY, 0), "tonnes) is recommended to allow stock rebuilding.\n")
} else {
  cat("- The stock is currently above B_MSY.\n")
  cat("- A catch limit at or near MSY (", round(MSY, 0), "tonnes) would be sustainable.\n")
}

cat("\nNote: These results should be interpreted with caution, considering the uncertainty\n")
cat("in parameter estimates and the simplifying assumptions of surplus production models.\n")
