# Deploy

This folder is where everything CD sees lives. It's organized by project, then cluster name, so that the CD pipelines can easily `cd` into the right directory to build their manifests. If you don't have secrets because you use vault or something, you could just apply the manifests in `../generated` instead.
