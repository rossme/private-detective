# Private Detective 🕵️
## A Ruby gem to analyze method visibility in your Ruby project

## Overview

Private Detective was created to address a common issue in Ruby projects where determining the appropriate visibility for class methods is sometimes overlooked. Often, it is not immediately clear whether a method should be private, protected or public. Private Detective simplifies this process by providing tools to analyze Ruby source code files, helping developers identify and refine the visibility of their methods.

## CLI Usage

To analyze all Ruby source files in the current directory, simply run:
    
 ```bash
 $ private_detective
 ```

## Why did I build this gem?

In real-world scenarios, it is common for public methods to inadvertently expose internal details, or for private methods to be unnecessarily restrictive. This can lead to issues with maintainability, code readability, and overall project health. Private Detective was developed to streamline the identification and rectification of such visibility issues, offering a clearer understanding of method visibility within Ruby projects.

More importantly, it was also a good excuse to look at the inner workings of the Rubocop gem and build a gem of my own exploring the Ruby file parser and to traverse AST nodes.

## How It Works

The Private Detective gem employs the following process to analyze method visibility in your Ruby project:

1. **Iteration Over Project Files:**
    - The gem iterates over your project files (currently app/models only), inspecting the Ruby source code.

2. **Parsing to AST Nodes:**
    - Each file is parsed into an Abstract Syntax Tree (AST) node using the `parser` gem.

3. **Traversing the AST:**
    - The gem traverses the AST nodes to identify class methods and their visibility modifiers: Private, Protected and the default Public.

4. **Visibility Analysis:**
    - Based on the identified methods and modifiers, Private Detective provides insights into potential issues related to method visibility.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'private_detective'
```

## Example response

```response
Private Detective found the following Class method information in your project:

Class: Client
  Method: test_method_rubocop_client, visibility: public
	Method contents:
		models/user.rb:10:4 User#test_method_rubocop private [Correctable]
		models/user.rb:11:4 User#test_private_method_rubocop protected [Correctable]
  Method: test_additional_method_example, visibility: private
  Method: test_additional_method_example_2, visibility: private

Class: Prompt
  Method: message_content, visibility: public

Class: User
  Method: test_method_rubocop, visibility: private
  Method: test_private_method_rubocop, visibility: protected

End of report
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rossme/private_detective.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
