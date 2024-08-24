document.addEventListener('DOMContentLoaded', function() {
    const terminalInput = document.getElementById('terminal-input');
    const terminalOutput = document.getElementById('terminal-output');
    const productsContainer = document.getElementById('products');

    const products = []; // Array to store products
    const cart = []; // Array to store cart elements

    const addToTerminalOutput = (text) => {
        terminalOutput.innerHTML += `<div>${text}</div>`;
        terminalOutput.scrollTop = terminalOutput.scrollHeight;
    }

    const fetchProducts = () => {
        fetch('https://fakestoreapi.com/products')
            .then(response => response.json())
            .then(data => {
                products.push(...data);
                displayProducts();
                addToTerminalOutput('Products loaded. Type "list" to see all products.');
            });
    }

    const displayProducts = () => {
        productsContainer.innerHTML = '';
        products.forEach((product, idx) => {
            const productElement = document.createElement('div');
            productElement.innerHTML = `
                <div class="card" style="width: 15rem;">
                    <img class="card-img-top" src="${product.image}" alt="Card image cap">
                    <div class="card-body">
                        <h4 class="card-title">${product.title}</h4>
                        <h5><strong>Price:</strong> $${product.price}</h5>
                        <p class="card-text">${product.description}</p>
                    </div>
                </div>
            `;
            productsContainer.appendChild(productElement);
        });
    }

    const handleCommand = (command) => {
        const commandParts = command.split(' ');
        const mainCommand = commandParts[0];

        var help = ["list: List all products\n"];
        help.push(["details [product_id]: View Product details\n"]);
        help.push(["add [product_id]: Add Product to cart\n"]);
        help.push(["remove [product_id]: Remove Product from cart\n"]);
        help.push(["cart: View your cart\n"]);
        help.push(["search [query]: Search product by name\n"]);
        help.push(["sort [price/name]: Sort products by price or name\n"]);
        help.push(["clear: Clear the screen "]);

        switch(mainCommand) {
            case 'list':
                terminalOutput.innerHTML += "<br />"
                addToTerminalOutput('>>> Listing all products:');
                products.forEach(product => addToTerminalOutput(`${product.id}: ${product.title}`));
                break;

            case 'clear':
                terminalOutput.innerHTML = '';
                break;

            case 'help':
                terminalOutput.innerHTML += "<br />"
                addToTerminalOutput(">>> Listing all commands");
                help.forEach(line => addToTerminalOutput(line));
                break;

            case 'details':
                terminalOutput.innerHTML += "<br />";
                let msg = "Product not found";

                for (let i=0; i<products.length; i++) {
                    if (products[i].id == commandParts[1]) {
                        msg = products[i].description;
                    }
                }

                addToTerminalOutput(">>> " + msg);
                break;

            case 'add':
                terminalOutput.innerHTML += "<br />";
                let prod = "";

                for (let i=0; i<products.length; i++) {
                    if (products[i].id == commandParts[1]) {
                        prod = products[i];
                    }
                }

                if (prod == "") {
                    addToTerminalOutput(">>> Product not found");
                } else {
                    cart.push(prod);
                    addToTerminalOutput(">>> Added `" + prod.title + "` to cart");
                }

                break;

            case 'remove':
                terminalOutput.innerHTML += "<br />";
                let ele = "";

                for (let i=0; i<products.length; i++) {
                    if (products[i].id == commandParts[1]) {
                        ele = products[i];
                    }
                }

                if (ele == "") {
                    addToTerminalOutput(">>> Product not found");
                } else {
                    cart.splice(cart.indexOf(ele));
                    addToTerminalOutput(">>> Deleted `" + ele.title + "` to cart");
                }

                break;

            case 'cart':
                terminalOutput.innerHTML += "<br />";
                addToTerminalOutput(">>> Listing all product in cart:");
                cart.forEach(ele => addToTerminalOutput(`${ele.id}: ${ele.title}`));
                break;

            case 'search':
                terminalOutput.innerHTML += "<br />";
                var keyword = commandParts[1];
                let item = [];

                for (let i=0; i<products.length; i++) {
                    if (products[i].title.toLowerCase().indexOf(keyword.toLowerCase()) > -1) {
                        item.push(products[i]);
                    }
                }

                if (item.length == 0) {
                    addToTerminalOutput(">>> Element not found !");
                } else {
                    addToTerminalOutput(">>> Showing all occurances of " + keyword);
                    item.forEach(i => addToTerminalOutput(`${i.id}: ${i.title}`));
                }

                break;

            case 'sort':
                terminalOutput.innerHTML += "<br />";
                var p_n = commandParts[1];
                var prod_obj = {};

                addToTerminalOutput(">>> Sorting as per " + p_n)

                products.forEach(item => {
                    prod_obj[item.title] = item;
                });

                if (p_n.toLowerCase() == "price") {
                    let sorted = Object.keys(prod_obj)
                        .sort((a, b) => prod_obj[a] - prod_obj[b])
                        .reduce((acc, key) => {
                            acc[key] = prod_obj[key];
                            return acc;
                        }, {});

                    Object.keys(sorted).forEach((k) => addToTerminalOutput(`${prod_obj[k].id}: ${k} => Rs. ${prod_obj[k].price}`));
                } else if (p_n.toLowerCase() == "name") {
                    let sorted = Object.keys(prod_obj)
                        .sort((a, b) => prod_obj[a].title.localeCompare(prod_obj[b].title))
                        .reduce((acc, key) => {
                            acc[key] = prod_obj[key];
                            return acc;
                        }, {});

                    Object.keys(sorted).forEach((k) => addToTerminalOutput(`${prod_obj[k].id}: ${k} => Rs. ${prod_obj[k].price}`));
                } else {
                    addToTerminalOutput("Unknown sorting parameter")
                }

                break;

            default:
                addToTerminalOutput(`Unknown command: ${command}`);
        }
    }

    terminalInput.addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            const command = terminalInput.value.trim();
            if (command) {
                handleCommand(command);
                terminalInput.value = '';
            }
        }
    });

    fetchProducts();
});
