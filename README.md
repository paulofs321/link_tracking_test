# Link Click Tracking (Ruby on Rails)

## Description Overview
This Rails 8 application tracks every link click within the `Posts` page, both to internal pages and external websites, and stores the link click details within the database under the `link_clicks` table.

## Core Features

### Controller

The primary logic for handling link clicks is contained in the `LinkClicksController`. The controller includes rate limiting to prevent abuse of the create action.

### Job
The `LinkClickJob` is responsible for handling the asynchronous processing of link click data. It ensures that the `Posts` page remains responsive by offloading the processing to a background job.

### Repository
The `LinkClickRepository` contains methods related to the management of link click data and any associated caching.

#### Cache Management
Cache Clearing: The cache is cleared when a link click is recorded to ensure data freshness.

### Stimulus Controller
To enhance user interaction with the Link Clicks feature, a Stimulus controller is implemented. This controller captures click events and sends the data to the server.

### Admin Page
A very simple admin page has been implemented to manage and view link click data. This page allows administrators to monitor user interactions and analyze trends.

Features of the Admin Page
View Click Data: Admins can view a list of relevant statistics of link clicks such as total number of link clicks, the most clicked URL, and the number of clicks overtime.
Filter Options: Options to filter link clicks by date.

## Installation

### Prerequisite

- Ensure you have Ruby 3.3.5 installed.

### Steps

1. **Clone the Repository**:

   ```bash
   git clone https://github.com/paulofs321/link_tracking_test.git
   cd your-repo-name

2. **Install Dependencies**:

   ```Run the following command to install the required gems:
   bundle install

3. **Set Up the Database**:

   ```bin/rails db:create
   bin/rails db:migrate

4. **Precompile the assets**:

  ```bin/rails assets:precompile

4. **Run the Server**:
   ```bin/rails server
