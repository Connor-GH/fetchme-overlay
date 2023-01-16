With this overlay, you should now be able to install fetchme through Gentoo's Portage package manager.

You can add the repository with ``eselect repository add fetchme-overlay git https://github.com/connor-gh/fetchme-overlay.git``

You then sync with ``emaint sync -r fetchme-overlay``

After accepting your respective keyword, you can install it with a basic ``emerge --ask app-misc/fetchme``.
