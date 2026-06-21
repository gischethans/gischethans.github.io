# Chethan's GitHub Pages Site

This is the source code for my personal website hosted on GitHub Pages. It is built using [Jekyll](https://jekyllrb.com/).

## Local Development

To run this site locally, you'll need to have Ruby and Bundler installed on your machine.

### Prerequisites

1.  **Ruby:** Ensure you have Ruby installed. You can check by running `ruby -v`. If you don't have it, or if it's the default system Ruby (which can cause permission issues), you can install a newer version via [Homebrew](https://brew.sh/) on a Mac:
    ```bash
    brew install ruby
    ```
    *Important:* After installing Ruby via Homebrew, you need to add it to your PATH so your terminal uses it instead of the system Ruby. Run these commands:
    ```bash
    echo 'export PATH="/opt/homebrew/opt/ruby/bin:$PATH"' >> ~/.zshrc
    export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
    ```
2.  **Bundler:** Install Bundler, which manages the Ruby gem dependencies for the project:
    ```bash
    gem install bundler
    ```

### Running the Site

1.  **Install dependencies:**
    Navigate to the project directory in your terminal and run:
    ```bash
    bundle install
    ```

2.  **Start the local server:**
    Run the following command to start the Jekyll development server:
    ```bash
    bundle exec jekyll serve
    ```
    Or, if you want the server to automatically regenerate the site when you make changes, and you're working on a draft:
    ```bash
    bundle exec jekyll serve --livereload
    ```

3.  **View the site:**
    Open your web browser and navigate to `http://localhost:4000/`.

## Creating a New Post

You can use the provided script to quickly create a new blog post:

```bash
./new-post.sh "My Post Title"
```

This creates a new Markdown file in `_posts/` with the correct date prefix and front matter, and a matching image directory under `assets/images/`.

### Social sharing image (Open Graph)

The `image:` field in the front matter controls the preview image shown when the post link is shared on LinkedIn, Twitter/X, WhatsApp, etc. The script pre-fills it with the path to the post's image directory — update it to point to the specific file once you have an image:

```yaml
image: /assets/images/2026-06-20-my-post-slug/my-image.png
```

Posts without an `image:` field will still share correctly, but with a plain text card instead of a visual preview.
