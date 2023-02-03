<div align="center">
   <image src="assets/onedrive-cf-index.png" alt="onedrive-cf-index" width="150px" />
   <h3><a href="https://storage.spencerwoo.com">onedrive-cf-index</a></h3>
   <em>OneDrive indexing powered by CloudFlare Workers</em>
</div>

---

<h5>This project uses CloudFlare Workers to help you deploy and share your OneDrive files for free. This project is largely derived from: <a href="https://github.com/heymind/OneDrive-Index-Cloudflare-Worker">onedrive-index-cloudflare-worker</a>, tribute. </h5>

## Demo

Online demo: [Spencer's OneDrive Index](https://storage.spencerwoo.com/).

![Screenshot Demo](assets/screenshot.png)

## Function

### 🚀 Feature List

- New "breadcrumbs" navigation bar;
- token credentials are automatically refreshed by Cloudflare Workers and kept in the (free) global KV store;
- Use [Turbolinks®](https://github.com/turbolinks/turbolinks) to implement lazy loading of routes;
- Support for versions of OneDrive operated by 21Vianet;
- Support for SharePoint deployment;

### 🗃️ directory index display

- A new design style that supports customization: [spencer.css](themes/spencer.css);
- Support for using Emoji as folder icon (if the first character of the folder name is Emoji, this function will be automatically enabled);
- Render `README.md` If the current directory contains this file, use [github-markdown-css](https://github.com/sindresorhus/github-markdown-css) to render the style;
- Support "pagination", there is no limit of 200 items in a directory!

### 📁 File online preview

- Render the file icon according to the file type, the icon uses [Font Awesome icons](https://fontawesome.com/);
- Support preview:
   - Plain text: `.txt`. [_DEMO_](https://storage.spencerwoo.com/%F0%9F%A5%9F%20Some%20test%20files/Previews/iso_8859-1.txt).
   - Markdown format text: `.md`, `.mdown`, `.markdown`. [_DEMO_](https://storage.spencerwoo.com/%F0%9F%A5%9F%20Some%20test%20files/Previews/i_m_a_md.md).
   - Images (Support Medium-style image scaling): `.png`, `.jpg`, and `.gif`. [_DEMO_](https://storage.spencerwoo.com/%F0%9F%A5%9F%20Some%20test%20files/Previews/).
   - Code highlighting: `.js`, `.py`, `.c`, `.json`... [_DEMO_](https://storage.spencerwoo.com/%F0%9F%A5%9F%20Some%20test%20files/Code/pathUtil.js).
   - PDF (support lazy loading, loading progress, Chrome built-in PDF reader): `.pdf`. [_DEMO_](<https://storage.spencerwoo.com/%F0%9F%A5%91%20Course%20PPT%20for%20CS%20(BIT)/2018%20-%20%E5%A4%A7%E4%BA%8C%E4%B8%8B%20-%20%E8%AE%A1%E7%AE%97%E6%9C%BA%E5%9B%BE%E5%BD%A2%E5%AD%A6/1%20FoundationofCG-Anonymous.pdf>).
   - Music: `.mp3`, `.aac`, `.wav`, `.oga`. [_DEMO_](https://storage.spencerwoo.com/%F0%9F%A5%9F%20Some%20test%20files/Multimedia/Elysian%20Fields%20-%20Climbing%20My%20Dark%20Hair.mp3).
   - Video: `.mp4`, `.flv`, `.webm`, `.m3u8`. [_DEMO_](https://storage.spencerwoo.com/%F0%9F%A5%9F%20Some%20test%20files/Multimedia/%E8%BD%A6%E5%BA%93%E5%A5%B3%E7%8E%8B%20%E9%AB%98%E8%B7%9F%E8%B9%A6%E8%BF%AA%20%E4%B9%98%E9%A3%8E%E7%A0%B4%E6%B5%AA%E7%9A%84%E5%A7%90%E5%A7%90%E4%B8%BB%E9%A2%98%E6%9B%B2%E3%80%90%E9%86%8B%E9%86%8B%E3%80%91.mp4).

### 🔒 Private folders

![Private folders](assets/private-folder.png)

We can lock a specific folder (directory) and require authentication to access it. We can write the directories we want to make private folders into the `ENABLE_PATHS` list in the `src/auth/config.js` file. We can also customize the user name `NAME` and password used for authentication, where the authentication password is saved in the `AUTH_PASSWORD` environment variable, which needs to be set using wrangler:

```bash
wrangler secret put AUTH_PASSWORD
# Enter your own authentication password here
```

Please refer to the [next paragraphs](#preparation) for details on how to use wrangler.

### ⬇️ Proxy to download files / file direct link access

- [Optional] Proxied download: `?proxied` - Download files via CloudFlare Workers if (1) `proxyDownload` in `config/default.js` is `true`, and (2) using Parameter `?proxied` request file;
- [Optional] Raw file download (direct file access): `?raw` - return the file direct link instead of the preview interface;
- Both parameters can be used together, i.e. `?proxied&raw` and `?raw&proxied` are both valid.

Yes, this means that you can use this project to build a "picture bed", or to build a static file deployment service, such as the following picture link:

```
https://storage.spencerwoo.com/%F0%9F%A5%9F%20Some%20test%20files/nyancat.gif?raw
```

![](https://storage.spencerwoo.com/%F0%9F%A5%9F%20Some%20test%20files/nyancat.gif?raw)

### Other functions

Please refer to the "🔥 New Features V1.1" section of the original project: [onedrive-index-cloudflare-worker](https://github.com/heymind/OneDrive-Index-Cloudflare-Worker#-%E6%96%B0%E7%89%B9%E6%80%A7-v11), **But I do not guarantee that all functions are available, because the changes in this project are very large. **

## Deployment Guide

_Warning for the stinky and long Chinese version of the deployment guide! _

### Generate OneDrive API Token

1. Visit this URL to create a new Blade app: [Microsoft Azure App registrations](https://portal.azure.com/#blade/Microsoft_AAD_RegisteredApps/ApplicationsListBlade) (normal version of OneDrive) or [Microsoft Azure.cn App registrations]( https://portal.azure.cn/#blade/Microsoft_AAD_RegisteredApps/ApplicationsListBlade) (OneDrive 21Vianet version) :

    1. Log in with your Microsoft account, select `New registration`;
    2. Set the name of the Blade app at `Name`, such as `my-onedrive-cf-index`;
    3. Set `Supported account types` to `Accounts in any organizational directory (Any Azure AD directory - Multitenant) and personal Microsoft accounts (e.g. Skype, Xbox)`. OneDrive 21Vianet user set to: `Account in any organizational directory (any Azure AD directory - multi-tenant)`;
    4. Set `Redirect URI (optional)` to `Web` (drop-down option box) and `http://localhost` (URL address);
    5. Click `Register`.

    ![](assets/register-app.png)

2. Get your Application (client) ID - `client_id` in the `Overview` panel:

    ![](assets/client-id.png)

3. Open the `Certificates & secrets` panel, click `New client secret`, create a new Client secret called `client_secret`, and set `Expires` to `Never`. Click `Add` and copy `client_secret` the `Value` and save it **(only one chance)**:

    ![](assets/add-client-secret.png)

4. Open the `API permissions` panel, select `Microsoft Graph`, select `Delegated permissions`, and search for the three permissions `offline_access, Files.Read, Files.Read.All`, **select these three permissions, and Click `Add permissions`:**

    ![](assets/add-permissions.png)

    You should successfully enable these three permissions:

    ![](assets/permissions-used.png)

5. Obtain `refresh_token`, and execute the following command on the local machine (need Node.js and npm environment, please refer to [Preparation](#Preparation) for installation and recommended configuration):

    ```sh
    npx @beetcb/ms-graph-cli
    ```

    <div align="center"><img src="https://raw.githubusercontent.com/beetcb/ms-graph-cli/master/media/demo.svg" alt="demo gif" width="560px" /></div>

    Choose the appropriate option according to your own situation, and enter a series of token token configurations we obtained above, among which `redirect_url` can be directly set to `http://localhost`. For the specific usage of command line tools, please refer to: [beetcb/ms-graph-cli](https://github.com/beetcb/ms-graph-cli).

6. Finally, create a public shared folder in our OneDrive, such as `/Public`. It is recommended not to share the root directory directly!

Finally, after all this tossing, we should have successfully obtained the following credentials:

- `refresh_token`
- `client_id`
- `client_secret`
- `redirect_uri`
- `base`: defaults to `/Public`.

_Yes, I know it's troublesome, but this is Microsoft, please understand. 🤷🏼‍♂️_

### Preparation

Fork and then clone or directly clone this warehouse, and install dependencies Node.js, `npm` and `wrangler`.

_It is strongly recommended that you use Node version manager such as [n](https://github.com/tj/n) or [nvm](https://github.com/nvm-sh/nvm) to install Node.js and` npm`, so that the `wrangler` we installed globally can install and save configuration files in our user directory, and we will not encounter strange permission problems. _

```sh
# Install CloudFlare Workers official compilation and deployment tool
npm i @cloudflare/wrangler -g

# install dependencies using npm
npm install

# Login to CloudFlare account with wrangler
wrangler login

# Use this command to check your login status
wrangler whoami
```

Open <https://dash.cloudflare.com/login>, log in to CloudFlare, choose your own domain name, ** and scroll down a bit, we can see our `account_id` and `zone_id` on the right column. ** At the same time, create a **DRAFT** worker at `Workers` -> `Manage Workers` -> `Create a Worker`.

Modify our [`wrangler.toml`](wrangler.toml):

- `name`: is the name of the draft worker we just created, and our Worker will be published under this domain name by default: `<name>.<worker_subdomain>.workers.dev`;
- `account_id`: our Cloudflare Account ID;
- `zone_id`: Our Cloudflare Zone ID.

Create a Cloudflare Workers KV bucket called `BUCKET`:

```sh
# create KV bucket
wrangler kv:namespace create "BUCKET"

# ... Alternatively, create a KV bucket that includes preview functionality
wrangler kv:namespace create "BUCKET" --preview
```

The preview function is only used for local testing, and has nothing to do with the image preview function on the page.

Modify `kv_namespaces` in [`wrangler.toml`](wrangler.toml):

- `kv_namespaces`: our Cloudflare KV namespace, just replace `id` and/or `preview_id`. _If you don't need the preview function, just remove `preview_id`. _

Modify [`src/config/default.js`](src/config/default.js):

- `client_id`: the OneDrive `client_id` just obtained;
- `base`: the previously created `base` directory;
- If you deploy the regular international version of OneDrive, then ignore the following steps;
- If you are deploying the China version of OneDrive operated by 21Vianet:
   - Modify `accountType` under `type` to `1`;
   - keep `driveType` unchanged;
- If you are deploying a SharePoint service:
   - leave `accountType` unchanged;
   - Modify `type` under `driveType` to `1`;
   - and modify `hostName` and `sitePath` according to your SharePoint service.

Use `wrangler` to add Cloudflare Workers environment variables (see [🔒 private folders](#-private folders) for authentication passwords):

```sh
# Add our refresh_token and client_secret
wrangler secret put REFRESH_TOKEN
# ... and paste our refresh_token here

wrangler secret put CLIENT_SECRET
# ... and paste our client_secret here

wrangler secret put AUTH_PASSWORD
# ... enter the authentication password we set here
```

### Add Required Packages
```
npm install font-awesome-filetypes marked
```

### Compile and deploy

We can preview the deployment using `wrangler`:

```sh
wrangler dev
```

If all goes well, we can publish the Cloudflare Worker with the following command:

```sh
wrangler publish
```

We can also create a GitHub Actions to automatically publish a new Worker every time `push` to the GitHub repository, for details, refer to: [main.yml](.github/workflows/main.yml).

If you want to deploy Cloudflare Worker under your own domain name, please refer to: [How to Setup Cloudflare Workers on a Custom Domain](https://www.andressevilla.com/how-to-setup-cloudflare-workers-on-a-custom-domain/).

## Customization of style and content

- We **should** change the default "landing page", directly modify the HTML of `intro` in [src/folderView.js](src/folderView.js#L51-L56);
- We also **should** change the header of the page, just modify [src/render/htmlWrapper.js](src/render/htmlWrapper.js#L29-L56) directly;
- The style CSS file is located at [themes/spencer.css](themes/spencer.css), you can customize this file according to your own needs, and you also need to update [src/render/htmlWrapper.js](src/render/htmlWrapper.js#L3) commit HASH in the file;
- We can also customize Markdown rendering CSS style, PrismJS code highlighting style, etc.
