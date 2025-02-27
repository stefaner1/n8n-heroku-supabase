# n8n-heroku

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://dashboard.heroku.com/new?template=https://github.com/stefaner1/n8n-heroku-supabase/tree/main)

## n8n - Free and open fair-code licensed node based Workflow Automation Tool.

This is a [Heroku](https://heroku.com/)-focused container implementation of [n8n](https://n8n.io/) that uses [Supabase](https://supabase.com/) for the database.

### Prerequisites
1. A Supabase project with your PostgreSQL database
2. Database connection string from Supabase project settings
! Important ! Use the Supabase Transaction Pooler URL:
Supabase provides a pooler URL option (often found in your project’s settings) that returns an IPv4 address. Switching to that URL will allow your app to connect over IPv4, which Heroku supports.

### Deployment
Use the **Deploy to Heroku** button above to launch n8n on Heroku. When deploying:
1. Set `N8N_ENCRYPTION_KEY` to a random secure value
2. Set `DATABASE_URL` to your Supabase PostgreSQL connection string (found in your Supabase project settings under Project Settings > Database)

Refer to the [Heroku n8n tutorial](https://docs.n8n.io/hosting/server-setups/heroku/) for more information.

If you have questions after trying the tutorials, check out the [forums](https://community.n8n.io/).
