# Grocery Management System

This is a simple command-line based Grocery Management System implemented in Bash. The system allows you to manage products, orders, inventory, sales, purchases, customers, suppliers, and invoices. It also integrates with eBMS for real-time invoice and stock movement synchronization.

## Features

- **Product Management**: Add, edit, delete, list, and search products.
- **Order Management**: Manage orders with functions to list, edit, cancel, and draft orders.
- **Inventory Management**: Track and manage inventory.
- **Sales Management**: Generate sales from order management or directly from the sales module.
- **Purchase Management**: Manage purchase transactions and stock features.
- **Customer Management**: Add, edit, delete, and list customers.
- **Supplier Management**: Add, edit, delete, and list suppliers.
- **Invoice Management**: Generate and cancel invoices, with synchronization to eBMS.
- **eBMS Integration**: Authenticate with eBMS and synchronize invoices and stock movements in real-time.

## Requirements

- Bash
- `curl`
- `jq`

Install `curl` and `jq` if they are not already installed:

```sh
sudo apt install curl jq
