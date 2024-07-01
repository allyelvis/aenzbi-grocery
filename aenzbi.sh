#!/bin/bash

# Database files for products, orders, sales, inventory, purchases, customers, and suppliers
DATABASE_DIR="databases"
PRODUCTS_DB="$DATABASE_DIR/products.txt"
ORDERS_DB="$DATABASE_DIR/orders.txt"
SALES_DB="$DATABASE_DIR/sales.txt"
INVENTORY_DB="$DATABASE_DIR/inventory.txt"
PURCHASES_DB="$DATABASE_DIR/purchases.txt"
CUSTOMERS_DB="$DATABASE_DIR/customers.txt"
SUPPLIERS_DB="$DATABASE_DIR/suppliers.txt"
INVOICE_DIR="$DATABASE_DIR/invoices"

# eBMS login credentials
EBMS_USERNAME=""
EBMS_PASSWORD=""
EBMS_BEARER_TOKEN=""

# eBMS API endpoints
EBMS_LOGIN_ENDPOINT="https://ebms.obr.gov.bi:9443/ebms_api/login"
EBMS_INVOICE_ENDPOINT="https://ebms.obr.gov.bi:9443/ebms_api/getInvoice"
EBMS_STOCK_MOVEMENT_ENDPOINT="https://ebms.obr.gov.bi:9443/ebms_api/stockMovement"
EBMS_CANCEL_INVOICE_ENDPOINT="https://ebms.obr.gov.bi:9443/ebms_api/cancelInvoice"

# Initialize the database files and directories if they don't exist
initialize_databases() {
    mkdir -p "$DATABASE_DIR"
    touch "$PRODUCTS_DB" "$ORDERS_DB" "$SALES_DB" "$INVENTORY_DB" "$PURCHASES_DB" "$CUSTOMERS_DB" "$SUPPLIERS_DB"
    mkdir -p "$INVOICE_DIR"
}

# Function to display menu and get user choice
display_menu() {
    clear
    echo "=== Grocery Management System Menu ==="
    echo "1. Product Management"
    echo "2. Order Management"
    echo "3. Inventory Management"
    echo "4. Sales Management"
    echo "5. Purchase Management"
    echo "6. Customer Management"
    echo "7. Supplier Management"
    echo "8. Invoice Management"
    echo "9. eBMS Login"
    echo "10. Exit"
    echo "====================================="
    read -p "Enter your choice: " choice
}

# Function to post data to eBMS endpoints
post_data_to_ebms() {
    local endpoint="$1"
    local data="$2"
    local bearer_token="$3"

    curl -sS -X POST -H "Authorization: Bearer $bearer_token" -H "Content-Type: application/json" -d "$data" "$endpoint"
}

# Login to eBMS
ebms_login() {
    clear
    echo "=== eBMS Login ==="
    read -p "Enter your eBMS username: " EBMS_USERNAME
    read -s -p "Enter your eBMS password: " EBMS_PASSWORD
    echo

    # Prepare login data
    login_data="{\"username\": \"$EBMS_USERNAME\", \"password\": \"$EBMS_PASSWORD\"}"

    # Post login request to eBMS endpoint
    response=$(curl -sS -X POST -H "Content-Type: application/json" -d "$login_data" "$EBMS_LOGIN_ENDPOINT")

    # Extract bearer token from response (assuming JSON response with "token" field)
    EBMS_BEARER_TOKEN=$(echo "$response" | jq -r '.token')

    if [ -n "$EBMS_BEARER_TOKEN" ]; then
        echo "Login successful. Bearer token obtained."
    else
        echo "Login failed. Please check your credentials."
    fi

    read -p "Press Enter to continue..."
}

# Product Management Functions
product_management() {
    while true
    do
        clear
        echo "=== Product Management ==="
        echo "1. Add Product"
        echo "2. Edit Product"
        echo "3. Delete Product"
        echo "4. List All Products"
        echo "5. Search Product"
        echo "6. Back to Main Menu"
        echo "=========================="
        read -p "Enter your choice: " product_choice

        case $product_choice in
            1) add_product ;;
            2) edit_product ;;
            3) delete_product ;;
            4) list_all_products ;;
            5) search_product ;;
            6) break ;;
            *) echo "Invalid choice. Please enter a valid option." ;;
        esac
    done
}

add_product() {
    clear
    echo "=== Add Product ==="
    read -p "Enter product name: " name
    read -p "Enter product price: " price
    # Add more fields as needed (category, unit, etc.)
    echo "$name,$price" >> "$PRODUCTS_DB"
    echo "Product '$name' added successfully!"
    read -p "Press Enter to continue..."
}

edit_product() {
    clear
    echo "=== Edit Product ==="
    read -p "Enter product name to edit: " name
    # Search for product by name and edit details
    tmp_file=$(mktemp)
    found=false
    while IFS= read -r line
    do
        product_name=$(echo "$line" | cut -d',' -f1)
        if [[ "$product_name" == "$name" ]]; then
            read -p "Enter new price for $name: " new_price
            # Update product details
            echo "$name,$new_price" >> "$tmp_file"
            echo "Product '$name' updated successfully!"
            found=true
        else
            echo "$line" >> "$tmp_file"
        fi
    done < "$PRODUCTS_DB"
    if [ "$found" = false ]; then
        echo "Product '$name' not found."
    fi
    mv "$tmp_file" "$PRODUCTS_DB"
    read -p "Press Enter to continue..."
}

delete_product() {
    clear
    echo "=== Delete Product ==="
    read -p "Enter product name to delete: " name
    # Search for product by name and delete
    tmp_file=$(mktemp)
    found=false
    while IFS= read -r line
    do
        product_name=$(echo "$line" | cut -d',' -f1)
        if [[ "$product_name" == "$name" ]]; then
            echo "Product '$name' deleted successfully!"
            found=true
        else
            echo "$line" >> "$tmp_file"
        fi
    done < "$PRODUCTS_DB"
    if [ "$found" = false ]; then
        echo "Product '$name' not found."
    fi
    mv "$tmp_file" "$PRODUCTS_DB"
    read -p "Press Enter to continue..."
}

list_all_products() {
    clear
    echo "=== List of All Products ==="
    cat "$PRODUCTS_DB"
    read -p "Press Enter to continue..."
}

searchsearch_product() {
    clear
    echo "=== Search Product ==="
    read -p "Enter product name to search: " name

    # Search for product by name and display details
    found=false
    while IFS= read -r line
    do
        product_name=$(echo "$line" | cut -d',' -f1)
        if [[ "$product_name" == "$name" ]]; then
            echo "Product found:"
            echo "$line"
            found=true
            break  # Stop searching after finding the product
        fi
    done < "$PRODUCTS_DB"

    if [ "$found" = false ]; then
        echo "Product '$name' not found."
    fi

    read -p "Press Enter to continue..."
}
