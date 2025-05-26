
# Set seed for reproducibility
set.seed(123)

# Simulate data
n <- 100  # Number of observations
fish_size <- runif(n, min = 10, max = 50)  # Fish sizes between 10 and 50 cm
# Temperature with some relationship to fish size plus random noise
temperature <- 15 + 0.2 * fish_size + rnorm(n, mean = 0, sd = 2)

# Create a data frame
fish_data <- data.frame(fish_size = fish_size, temperature = temperature)

# Look at the first few rows
head(fish_data)


# Fit linear model
model <- lm(temperature ~ fish_size, data = fish_data)

# View summary of the model
summary(model)


# Basic plot
plot(fish_data$fish_size, fish_data$temperature, 
     main = "Relationship Between Fish Size and Temperature",
     xlab = "Fish Size (cm)", ylab = "Temperature (°C)",
     pch = 19, col = "blue")

# Add regression line
abline(model, col = "red", lwd = 2)

# Add confidence interval (optional)
confint_data <- predict(model, interval = "confidence")
lines(sort(fish_data$fish_size), confint_data[order(fish_data$fish_size), "lwr"], 
      col = "darkgrey", lty = 2)
lines(sort(fish_data$fish_size), confint_data[order(fish_data$fish_size), "upr"], 
      col = "darkgrey", lty = 2)

# Add legend
legend("topleft", legend = c("Data points", "Regression line", "95% Confidence interval"),
       col = c("blue", "red", "darkgrey"), pch = c(19, NA, NA), 
       lty = c(NA, 1, 2), lwd = c(NA, 2, 1))


# Diagnostic plots
par(mfrow = c(2, 2))
plot(model)
par(mfrow = c(1, 1))

