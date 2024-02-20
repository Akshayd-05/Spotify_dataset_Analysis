cat("\014") # clears console
rm(list = ls()) # clears global environment
try(dev.off(dev.list()["RStudioGD"]), silent = TRUE) # clears plots
try(p_unload(p_loaded(), character.only = TRUE), silent = TRUE) #clears packages
options(scipen = 100) # disables scientific notion for entire R session


library(pacman)
library(plyr)
library(dplyr)
library(tidyverse)
library(psych)
library(corrplot)
library(stargazer)


#Read the dataset using read.csv function
df <- read.csv('spotify_songs.csv')
print(df)




#create a data frame with the spotify dataset
spotify_df <- data.frame(df, stringsAsFactors = FALSE)
print(spotify_df)
head(spotify_df, 5)
describe(spotify_df)


#Names of all the columns
names(spotify_df)





#Check the missing values in the data frame
sapply(spotify_df, function(x) sum(is.na(spotify_df)))





#Omit all the na values from the spotify dataset
spotify_df<- na.omit(spotify_df)
print(spotify_df)




#Number of nulls in the dataset
sum(is.na(spotify_df))




# Removing duplicates from the dataset
spotify_df <- unique(spotify_df)
print(spotify_df)





# Identify outliers using IQR
Q1 <- quantile(spotify_df$key, 0.25)
Q3 <- quantile(spotify_df$key, 0.75)
IQR <- Q3 - Q1
# Calculate lower and upper bounds
lower_bound <- Q1 - 1.5 * IQR
lower_bound
upper_bound <- Q3 + 1.5 * IQR
upper_bound
# Filter out rows with key values outside the bounds
spotify_df <- spotify_df[spotify_df$key >= lower_bound & spotify_df$key <= upper_bound, ]
print(spotify_df)






#Remove the columns which are not helpful in the data processing
spotify_df <- subset(spotify_df, select = -c(playlist_subgenre, acousticness, instrumentalness, liveness))
print(spotify_df)





# Bar chart of average popularity by genre
ggplot(spotify_df, aes(x = playlist_genre, y = track_popularity, fill = playlist_genre)) +
  geom_bar(stat = "summary", fun = "mean") +
  ggtitle("Average Popularity by Genre") +
  xlab("Genre") +
  ylab("Average Popularity")




# Bar chart for genres
ggplot(spotify_df, aes(x = playlist_genre)) +
  geom_bar(fill= "blue", col = "black") +
  labs(title = "Distribution of Genres",
       x = "Genre",
       y = "Count")






# Histogram for song duration
ggplot(spotify_df, aes(x = duration_ms)) +
  geom_histogram(binwidth = 10000, fill = "tan1", color = "black") +
  labs(title = "Distribution of Song Duration",
       x = "Duration (ms)",
       y = "Count")






# Scatter plot for danceability vs. energy
ggplot(spotify_df, aes(x = danceability, y = energy)) +
  geom_point(color = "black") +
  labs(title = "Danceability vs. Energy",
       x = "Danceability",
       y = "Energy")







# Box plot for popularity by genre
ggplot(spotify_df, aes(x = playlist_genre, y = track_popularity)) +
  geom_boxplot(fill = "skyblue", color = "black") +
  labs(title = "Popularity by Genre",
       x = "Genre",
       y = "Popularity")







# Select only numerical columns from the Spotify dataset
numerical_cols <- spotify_df[sapply(spotify_df, is.numeric)]
# Generate descriptive statistics for numerical columns
spotify_stats <- describe(numerical_cols)
# Print the statistics table
print(spotify_stats)



#Summary of the spotify dataset
summary(spotify_df)








# Group by artist and calculate maximum and minimum popularity
grouped_artist <- spotify_df %>%
  group_by(track_artist) %>%
  summarise(max_popularity = max(track_popularity), min_popularity = min(track_popularity))
print(grouped_artist)

# Select only numerical columns for descriptive statistics
numerical_cols1 <- grouped_artist[, c("max_popularity", "min_popularity")]
# Use describe function on numerical columns
describe(numerical_cols1)






# Group by year and calculate the number of tracks released each year
grouped_no_tracks <- spotify_df %>%
  group_by(track_album_release_date) %>%
  summarise(num_tracks = n())
print(grouped_no_tracks)
# Extract the numerical column
numerical_col2 <- grouped_no_tracks$num_tracks

# Use summary function on the numerical column
summary(numerical_col2)







# Group by mode and calculate the average tempo for major and minor mode
grouped_tempo <- spotify_df %>%
  group_by(mode) %>%
  summarise(avg_tempo = mean(tempo))
print(grouped_tempo)
# Use describe function on numerical columns
describe(grouped_tempo)






# Group by genre and calculate mean popularity and mean duration for each genre
grouped_genre <- spotify_df %>%
  group_by(playlist_genre) %>%
  summarise(mean_popularity = mean(track_popularity), mean_duration = mean(duration_ms))
print(grouped_genre)







# Group by artist and genre, calculate the total number of tracks for each combination
grouped_artist <- spotify_df %>%
  group_by(track_artist, playlist_genre) %>%
  summarise(total_tracks = n())
print(grouped_artist)
# Select only numerical columns for descriptive statistics
numerical_cols2 <- grouped_artist[, c("total_tracks")]

# Use describe function on numerical column
summary(numerical_cols2)







# Subset the data for the "Pop" genre
pop_data <- spotify_df[spotify_df$playlist_genre == "pop", ]
print(pop_data)
# Histogram of Popularity for Pop Genre
ggplot(pop_data, aes(x = track_popularity, fill = playlist_genre)) +
  geom_histogram(binwidth = 5, alpha = 0.7) +
  labs(title = "Popularity Distribution of Pop Genre Tracks",
       x = "Popularity",
       y = "Count",
       fill = "Genre")







# Subset the data for tracks with popularity greater than 80
high_popularity_data <- spotify_df[spotify_df$track_popularity > 80, ]
#Histogram of Energy for Tracks with High Popularity
ggplot(high_popularity_data, aes(x = energy, fill = playlist_genre)) +
  geom_histogram(binwidth = 0.05, alpha = 0.7) +
  labs(title = "Energy Distribution of Tracks with High Popularity",
       x = "Energy",
       y = "Count",
       fill = "Genre")






#Question1: Is the mean speechiness of all songs significantly different from a certain value (e.g., 0.2)?
#H0:The mean speechiness of all songs is equal to 0.2.
#Ha: The mean speechiness of all songs is different from 0.2.

#'speechiness' is the variable representing song speechiness
mu_speechiness <- 0.2
one_sample_t_test_result1 <- t.test(spotify_df$speechiness, mu = mu_speechiness)
print(one_sample_t_test_result1)
# Set the significance level (alpha)
alpha <- 0.05

# Extract p-value
p_value_speechiness <- one_sample_t_test_result1$p.value
# Print the result
if (p_value_speechiness < alpha) {
  cat("Reject the null hypothesis. There is significant evidence that the mean speechiness of all songs is different from", mu_speechiness)
} else {
  cat("Fail to reject the null hypothesis. There is not enough evidence to conclude that the mean speechiness of all songs is different from", mu_speechiness)
}

# Plot histogram of speechiness
hist(spotify_df$speechiness, main = "Distribution of Speechiness", xlab = "Speechiness", col = "tan1")




#Question2: Is there sufficient evidence to conclude that the mean valence of all songs in the Spotify dataset is different from the widely accepted average valence level of 0.5?
#H0: The mean valence of all songs is equal to 0.5.
#H1: The mean valence of all songs is different from 0.5.

# 'valence' is the variable representing the valence of songs
mu_valence <- 0.5
alpha <- 0.05

# Perform one-sample t-test
one_sample_t_test_result_valence <- t.test(spotify_df$valence, mu = mu_valence)
print(one_sample_t_test_result_valence)

# Extract p-value
p_value_valence <- one_sample_t_test_result_valence$p.value

# Print the result
if (p_value_valence < alpha) {
  cat("Reject the null hypothesis. There is significant evidence that the mean valence of all songs is different from", mu_valence)
} else {
  cat("Fail to reject the null hypothesis. There is not enough evidence to conclude that the mean valence of all songs is different from", mu_valence)
}

# Plot a histogram for the 'valence' variable
ggplot(spotify_df, aes(x = valence)) +
  geom_histogram(binwidth = 0.1, fill = "blue", color = "black", alpha = 0.7) +
  labs(title = "Distribution of Valence in Spotify Songs",
       x = "Valence",
       y = "Frequency")






#Question3: Is there a significant difference in mean energy between songs in Rock and pop playlists genre?
#H0:he mean energy of songs in Rock playlists is equal to the mean energy of songs in pop playlists.

#Ha: The mean energy of songs in Rock playlists is different from the mean energy of songs in pop playlists.
#'energy' is the variable representing song energy
# and 'playlist_genre' is the variable representing the genre in our dataset
rock_genre <- spotify_df$energy[spotify_df$playlist_genre == "rock"]
pop_genre <- spotify_df$energy[spotify_df$playlist_genre == "pop"]
two_sample_t_test_result1 <- t.test(rock_genre, pop_genre)
print(two_sample_t_test_result1)

# Extract p-value
p_value <- two_sample_t_test_result1$p.value

# Compare p-value to alpha
if (p_value < alpha) {
  cat("Reject the null hypothesis. There is significant evidence of a difference in mean energy between Rock and Pop playlists.")
} else {
  cat("Fail to reject the null hypothesis. There is not enough evidence to conclude a difference in mean energy between Rock and Pop playlists.")
}

# Ensure equal lengths
min_length_energy <- min(length(rock_genre), length(pop_genre))
rock_genre <- head(rock_genre, min_length_energy)
pop_genre <- head(pop_genre, min_length_energy)

# Create a dataframe for visualization
df_visualization_energy <- data.frame(
  Genre = rep(c("Rock", "Pop"), each = min_length_energy),
  Energy = c(rock_genre, pop_genre)
)

# Boxplot for Energy Between Rock and Pop Playlists
ggplot(df_visualization_energy, aes(x = Genre, y = Energy, fill = Genre)) +
  geom_boxplot() +
  labs(title = "Comparison of Energy Between Rock and Pop Playlists",
       x = "Genre",
       y = "Energy") +
  theme_minimal()



#question 4:Is there a significant difference in the mean danceability between songs in Rock and rap playlists?
#H0:The mean danceability of songs in r&b playlists is equal to the mean danceability of songs in rap playlists.
#Ha:The mean danceability of songs in r&b playlists is different from the mean danceability of songs in rap playlists.
#'danceability' is the variable representing song danceability
# and 'playlist_genre' is the variable representing the genre in our dataset
rb_danceability <- spotify_df$danceability[spotify_df$playlist_genre == "r&b"]
rap_danceability <- spotify_df$danceability[spotify_df$playlist_genre == "rap"]

# Perform two-sample t-test
two_sample_t_test_result2 <- t.test(rb_danceability, rap_danceability)
print(two_sample_t_test_result2)
# Extract p-value
p_value <- two_sample_t_test_result2$p.value


# Print the result
if (p_value < alpha) {
  cat("Reject the null hypothesis. There is significant evidence that the mean danceability of songs in Rock and Electronic playlists is different.")
} else {
  cat("Fail to reject the null hypothesis. There is not enough evidence to conclude that the mean danceability of songs in Rock and Electronic playlists is different.")
}


# Histogram for the danceability between R&B and Rap playlist
ggplot() +
  geom_histogram(data = data.frame(Danceability = rb_danceability), aes(x = Danceability, fill = "R&B"), alpha = 0.7, binwidth = 0.05) +
  geom_histogram(data = data.frame(Danceability = rap_danceability), aes(x = Danceability, fill = "Rap"), alpha = 0.7, binwidth = 0.05) +
  labs(title = "Histogram of Danceability Between R&B and Rap Playlists",
       x = "Danceability",
       y = "Frequency") +
  scale_fill_manual(values = c("R&B" = "skyblue", "Rap" = "salmon")) +
  theme_minimal()





# Select relevant variables for correlation
selected_variables <- spotify_df %>%
  select(track_popularity, key, mode, duration_ms, tempo )

# Create a correlation matrix
correlation_matrix <- cor(selected_variables)

# Display the correlation matrix
print(correlation_matrix)

# Create a correlation plot (chart)
corrplot(correlation_matrix, method = "color")

# Export to text file
write.table(correlation_matrix, file = "correlation_matrix_Final.txt")






# Let's say 'track_popularity' is the outcome variable, and 'key', 'energy', 'speechiness' are predictor variables
regression_model <- lm(track_popularity ~ key + energy + speechiness , data = spotify_df)

# Print summary of the regression model
summary(regression_model)

# 'regression_model' is our regression model
stargazer(regression_model, out = "regression_table_Final.html", type = "html")





#Question 1: Is there a significant relationship between song duration and popularity?
#Null Hypothesis (H0): There is no significant relationship between song duration and popularity.
#Alternative Hypothesis (H1): There is a significant relationship between song duration and popularity.


#plot the scatterplot of Duration vs popularity
plot(spotify_df$duration_ms, spotify_df$track_popularity, main="Scatterplot of Duration vs. Popularity", xlab="Duration (ms)", ylab="Popularity")


# Perform linear regression
lm_result1 <- lm(track_popularity ~ duration_ms, data=spotify_df)


# Print summary statistics
summary(lm_result1)





#Question 2: Does the tempo of a song have a significant effect on its popularity?
#Null Hypothesis (H0): There is no significant effect of tempo on popularity.
#Alternative Hypothesis (H1): There is a significant effect of tempo on popularity.

#plot the scatterplot of tempo vs popularity
plot(spotify_df$tempo, spotify_df$track_popularity, main="Scatterplot of Tempo vs. Popularity", xlab="Tempo (BPM)", ylab="Popularity")

# Perform linear regression
lm_result2 <- lm(track_popularity ~ tempo, data=spotify_df)

# Print summary statistics
summary(lm_result2)




#Question 3: Is there a significant relationship between the danceability of a song and its energy level, and does this relationship predict the song's popularity?
#Null Hypothesis (H0): There is no significant relationship between danceability and energy, and these variables do not predict popularity.
#Alternative Hypothesis (H1): There is a significant relationship between danceability and energy, and these variables predict popularity.

#plot the scatterplot of Danceability vs Energy
plot(spotify_df$danceability, spotify_df$energy, main="Scatterplot of Danceability vs. Energy", xlab="Danceability", ylab="Energy", col="green", pch=16)

# Perform linear regression
lm_result3 <- lm(track_popularity ~ danceability + energy, data=spotify_df)

# Print summary statistics
summary(lm_result3)
