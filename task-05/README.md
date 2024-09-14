# TerminalTrolly
I completed the **TerminalTrolly**, by creating an interactive terminal-based interface for an online hypermarket using HTML, CSS, and JavaScript. This challenge tested my ability to design and implement a functional e-commerce system where users can interact with a terminal to browse, manage, and purchase products via a terminal command system.

## Objective:
The task was divided into two main parts:
1. **UI Creation**: Design the terminal interface using HTML and CSS, ensuring it reflects the demo video provided.
2. **Terminal Functionality**: Implement functional terminal commands using JavaScript to interact with the provided API (`https://fakestoreapi.com`), mimicking real-life e-commerce transactions.

### 1. UI Creation

**Approach**: 
I used HTML to structure the terminal and CSS to style it, added responsiveness and modern design. The design included a two-column layout where the left side displayed the terminal, and the right side displayed the available products fetched from the API.

**Steps Taken**:
- **HTML**: Created the terminal structure and a container for the product listing.
- **CSS**: Responsiveness by using flexbox and media queries. Applied Material Design for a modern look, focusing on box shadows, hover effects, and clear typography.

### 2. Terminal Command Implementation

I implemented the following commands using JavaScript:

- **`list`**: This command fetched and displayed all available products from the API. I used `fetch()` to make a GET request to `https://fakestoreapi.com/products` and dynamically rendered the product list on the terminal.

- **`details 'product_id'`**: This command fetched the details of a specific product based on its ID. I used string parsing to extract the product ID from the user input and then fetched the product details using the API (`/products/{id}`).

- **`add 'product_id'`**: This command added a product to the shopping cart by storing the selected product in a cart array in localStorage.

- **`remove 'product_id'`**: This command removed a specific product from the cart by checking the ID and deleting it from the array.

- **`cart`**: This command displayed the current items in the cart by iterating over the stored cart array and rendering each product in the terminal.

- **`buy`**: On execution, this command redirected the user to a new webpage that displayed the cart’s content, total price, and allowed for a mock checkout process. I implemented this using `window.location.href` to move to a checkout page and used JavaScript to calculate the total price.

- **`clear`**: This command cleared the terminal output by resetting the displayed text area.

- **`search 'product_name'`**: This command searched for a product by name. I filtered through the fetched product data and displayed matching results.

- **`sort 'price/name'`**: Sorting was implemented based on the command. I applied a sorting function to the list based on either price or name using JavaScript's array `.sort()` method.

## Work Flow:
### 1. **DOM Content Loaded Event**
This event listener ensures the code runs only after the HTML content is fully loaded, ensuring that the DOM elements are available when the script is executed.

### 2. **HTML Element References**
These three variables reference elements from the DOM:
- `terminalInput`: The input field where users type their commands.
- `terminalOutput`: The div where the terminal output is displayed.
- `productsContainer`: The section where products will be visually displayed as cards.

### 3. **Products and Cart Arrays**
There are two arrays that store the list of products fetched from the API and the items added to the cart, respectively.

### 4. **Function to Output Text to Terminal**
This function appends text to the terminal output and automatically scrolls to the bottom so that the most recent command is visible.

### 5. **Fetching Products from API `fetchProducts()`**
- This function fetches products from `fakestoreapi.com`.
- Once the data is received, it pushes the product objects into the `products` array.
- It then calls `displayProducts()` to show them in the UI and provides feedback in the terminal that the products have been loaded.

### 6. **Displaying Products `displayProducts()`**
This function creates a card for each product and appends it to the `productsContainer` div. It displays the product image, title, price, and description.

### 7. **Handling User Commands `handleCommand()`**
The `handleCommand` function is responsible for interpreting and executing user commands. It splits the input string by spaces and extracts the main command. The supported commands are `list`, `details`, `add`, `remove`, `cart`, `search`, `sort`, `clear`, and `help`.

#### **Command Logic (Switch Case)**

1. **List Command**: Lists all the product names and IDs.

2. **Clear Command**: Clears the terminal screen.

3. **Help Command**: Displays all available commands.

4. **Details Command**: Shows details of a product based on the ID.

5. **Add Command**: Adds a product to the cart by ID.

6. **Remove Command**: Removes a product from the cart by ID.

7. **Cart Command**: Displays all the items currently in the cart.

8. **Search Command**: Searches for products by name.

9. **Sort Command**: Sorts products by price or name.

### 8. **Listening for Commands**
This event listener listens for the `Enter` key press, captures the command input, and processes it using the `handleCommand()` function.

### 9. **Initializing with Product Fetch**
Finally, the `fetchProducts` function is called to load the products from the API when the page first loads.