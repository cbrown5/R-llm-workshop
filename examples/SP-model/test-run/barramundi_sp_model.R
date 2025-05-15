# Surplus Production Model for Barramundi in the Gulf of Carpentaria
# ----------------------------------------------------------------

# Load required libraries
library(ggplot2)
library(dplyr)

# Read the data
barra_data <- read.csv("Data for Barramundi model.csv")

# Examine the data structure
str(barra_data)
summary(barra_data)

# Calculate CPUE (Catch per Unit Effort)
barra_data$cpue <- barra_data$Barramundicatch / barra_data$Effort

# Plot the time series of catch, effort, and CPUE
par(mfrow=c(3,1))
plot(barra_data$Year, barra_data$Barramundicatch, type="l", 
     xlab="Year", ylab="Catch (t)", main="Barramundi Catch")
plot(barra_data$Year, barra_data$Effort, type="l", 
     xlab="Year", ylab="Effort", main="Fishing Effort")
plot(barra_data$Year, barra_data$cpue, type="l", 
     xlab="Year", ylab="CPUE", main="Catch Per Unit Effort")
par(mfrow=c(1,1))

# Check for relationship between CPUE and catch (to assess data contrast)
plot(barra_data$Barramundicatch, barra_data$cpue, 
     xlab="Catch", ylab="CPUE", main="CPUE vs Catch")
abline(lm(cpue ~ Barramundicatch, data=barra_data), col="red")

# Cross-correlation analysis between CPUE and catch
ccf_result <- ccf(barra_data$Barramundicatch, barra_data$cpue, 
                 main="Cross-correlation between Catch and CPUE")

# Fit Schaefer surplus production model
# ------------------------------------

# Define the Schaefer model function
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

# Objective function for optimization
objective <- function(params, data) {
  model_output <- schaefer_model(params, data)
  return(model_output$nll)
}

# Initial parameter values
init_params <- c(
  r = 0.3,        # Intrinsic growth rate
  K = 1000,       # Carrying capacity
  q = 0.1,        # Catchability coefficient
  B_init = 500    # Initial biomass
)

# Set lower and upper bounds for parameters
lower_bounds <- c(0.01, 100, 0.001, 50)
upper_bounds <- c(1.0, 10000, 1.0, 5000)

# Fit the model using optimization
fit <- optim(
  par = init_params,
  fn = objective,
  data = barra_data,
  method = "L-BFGS-B",
  lower = lower_bounds,
  upper = upper_bounds,
  control = list(maxit = 1000)
)

# Extract the best-fit parameters
best_params <- fit$par
names(best_params) <- c("r", "K", "q", "B_init")
print(best_params)

# Calculate model outputs with best parameters
model_output <- schaefer_model(best_params, barra_data)

# Calculate MSY and related reference points
MSY <- (best_params["r"] * best_params["K"]) / 4
B_MSY <- best_params["K"] / 2
F_MSY <- best_params["r"] / 2
E_MSY <- F_MSY / best_params["q"]

# Print key fishery parameters
cat("\nKey Fishery Parameters:\n")
cat("Intrinsic growth rate (r):", round(best_params["r"], 4), "\n")
cat("Carrying capacity (K):", round(best_params["K"], 0), "tonnes\n")
cat("Catchability coefficient (q):", round(best_params["q"], 6), "\n")
cat("Initial biomass (B_init):", round(best_params["B_init"], 0), "tonnes\n")
cat("Maximum Sustainable Yield (MSY):", round(MSY, 0), "tonnes\n")
cat("Biomass at MSY (B_MSY):", round(B_MSY, 0), "tonnes\n")
cat("Fishing mortality at MSY (F_MSY):", round(F_MSY, 4), "\n")
cat("Effort at MSY (E_MSY):", round(E_MSY, 0), "units\n")
cat("Current biomass (B_current):", round(model_output$biomass[length(model_output$biomass)], 0), "tonnes\n")
cat("Current depletion (B_current/K):", round(model_output$biomass[length(model_output$biomass)]/best_params["K"], 2), "\n")

# Plot model fit
years <- barra_data$Year
n_years <- length(years)
plot_years <- c(min(years):max(years))

# Plot observed vs predicted CPUE
plot(years, barra_data$cpue, type="p", pch=16, 
     xlab="Year", ylab="CPUE", main="Observed vs Predicted CPUE")
lines(years, model_output$pred_cpue, col="red", lwd=2)
legend("topright", legend=c("Observed", "Predicted"), 
       pch=c(16, NA), lty=c(NA, 1), col=c("black", "red"))

# Plot estimated biomass trajectory
# Ensure biomass vector length matches plot_years length
biomass_to_plot <- model_output$biomass[1:(length(plot_years))]
plot(plot_years, biomass_to_plot, type="l", lwd=2,
     xlab="Year", ylab="Biomass (tonnes)", main="Estimated Biomass Trajectory")
abline(h=B_MSY, col="green", lty=2)
abline(h=0.2*best_params["K"], col="red", lty=2)
legend("topright", legend=c("Estimated Biomass", "B_MSY", "0.2K (Limit)"), 
       lty=c(1, 2, 2), col=c("black", "green", "red"))

# Plot phase plot (B/K vs Harvest Rate)
harvest_rate <- barra_data$Barramundicatch / model_output$biomass[1:length(years)]
depletion <- model_output$biomass[1:length(years)] / best_params["K"]

plot(depletion, harvest_rate, type="p", pch=16,
     xlab="Biomass Depletion (B/K)", ylab="Harvest Rate (C/B)",
     main="Phase Plot", xlim=c(0, 1))
points(depletion[length(depletion)], harvest_rate[length(harvest_rate)], 
       pch=16, col="red", cex=1.5)
abline(v=0.5, col="green", lty=2)  # B_MSY/K = 0.5 for Schaefer model
abline(v=0.2, col="red", lty=2)    # 0.2K limit reference point
abline(h=F_MSY, col="blue", lty=2) # F_MSY reference
text(depletion[length(depletion)], harvest_rate[length(harvest_rate)], 
     labels=paste("Current (", max(years), ")", sep=""), pos=4)

# Perform projections for different harvest strategies
# --------------------------------------------------

# Function to project biomass forward
project_biomass <- function(B_start, r, K, annual_catch, years) {
  B <- numeric(years + 1)
  B[1] <- B_start
  
  for (i in 1:years) {
    B[i+1] <- B[i] + r*B[i]*(1-B[i]/K) - annual_catch
    if (B[i+1] < 0) B[i+1] <- 0.01
  }
  
  return(B)
}

# Set up projection scenarios
current_biomass <- model_output$biomass[length(model_output$biomass)]
projection_years <- 10
catch_scenarios <- c(0.8*MSY, MSY, 1.2*MSY)
names(catch_scenarios) <- c("80% of MSY", "MSY", "120% of MSY")

# Run projections
projections <- list()
for (i in 1:length(catch_scenarios)) {
  projections[[i]] <- project_biomass(
    current_biomass, 
    best_params["r"], 
    best_params["K"], 
    catch_scenarios[i], 
    projection_years
  )
}

# Plot projections
projection_years_axis <- max(years):(max(years) + projection_years)
plot(plot_years, model_output$biomass, type="l", lwd=2,
     xlim=c(min(years), max(years) + projection_years),
     xlab="Year", ylab="Biomass (tonnes)", 
     main="Biomass Projections Under Different Harvest Strategies")
abline(v=max(years), col="gray", lty=2)
abline(h=B_MSY, col="green", lty=2)
abline(h=0.2*best_params["K"], col="red", lty=2)

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

# Function to generate bootstrap samples
bootstrap_samples <- function(data, model_output, n_samples) {
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
      par = best_params,
      fn = objective,
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

# Run bootstrap
bootstrap_results <- bootstrap_samples(barra_data, model_output, n_bootstrap)

# Calculate confidence intervals for parameters
ci_results <- apply(bootstrap_results, 2, quantile, probs=c(0.025, 0.5, 0.975))
print(ci_results)

# Calculate MSY for each bootstrap sample
bootstrap_MSY <- (bootstrap_results[,"r"] * bootstrap_results[,"K"]) / 4
MSY_ci <- quantile(bootstrap_MSY, probs=c(0.025, 0.5, 0.975))

cat("\nBootstrap Results (95% Confidence Intervals):\n")
cat("MSY:", round(MSY_ci[2], 0), "tonnes (", 
    round(MSY_ci[1], 0), "-", round(MSY_ci[3], 0), ")\n", sep="")

# Plot histograms of bootstrap parameter estimates
par(mfrow=c(2,2))
hist(bootstrap_results[,"r"], main="r", xlab="Intrinsic Growth Rate")
abline(v=best_params["r"], col="red", lwd=2)

hist(bootstrap_results[,"K"], main="K", xlab="Carrying Capacity")
abline(v=best_params["K"], col="red", lwd=2)

hist(bootstrap_results[,"q"], main="q", xlab="Catchability")
abline(v=best_params["q"], col="red", lwd=2)

hist(bootstrap_MSY, main="MSY", xlab="Maximum Sustainable Yield")
abline(v=MSY, col="red", lwd=2)
par(mfrow=c(1,1))

# Save results
save(best_params, model_output, MSY, B_MSY, F_MSY, bootstrap_results, 
     file="barramundi_sp_model_results.RData")

# Create a summary report
cat("\nSurplus Production Model Results for Barramundi in the Gulf of Carpentaria\n")
cat("==================================================================\n\n")
cat("Model fit statistics:\n")
cat("Negative log-likelihood:", round(fit$value, 2), "\n")
cat("Convergence code:", fit$convergence, "\n\n")

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
cat("F_MSY:", round(F_MSY, 4), "\n")
cat("E_MSY:", round(E_MSY, 0), "units\n\n")

cat("Current stock status:\n")
cat("Current biomass:", round(model_output$biomass[length(model_output$biomass)], 0), "tonnes\n")
cat("Depletion level (B/K):", round(model_output$biomass[length(model_output$biomass)]/best_params["K"], 2), "\n")
cat("Current harvest rate:", round(harvest_rate[length(harvest_rate)], 4), "\n")
cat("Status relative to MSY: ", ifelse(model_output$biomass[length(model_output$biomass)] > B_MSY, "Above", "Below"), " B_MSY\n", sep="")
