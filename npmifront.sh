#!/bin/bash

# Verifica si se proporcionó un nombre de proyecto
if [ -z "$1" ]; then
    read -e -p "📝 Nombre de la carpeta para el proyecto: " PROJECT_NAME
else
  PROJECT_NAME=$1
fi

# Verifica si el nombre del proyecto está vacío
if [ -z "$PROJECT_NAME" ]; then
  echo "❌ No se definió un nombre para la carpeta"
  exit 1
fi

# Convierte el nombre del proyecto a minúsculas para usarlo en el nombre del paquete
PACKAGE_NAME=$(echo "$PROJECT_NAME-app" | tr '[:upper:]' '[:lower:]')

# Crea la carpeta principal del proyecto y entra en ella
mkdir "$PROJECT_NAME"
cd "$PROJECT_NAME"

# Crear un .env para variables de entorno
echo 'VITE_API_URL = "http://localhost:3000"' > .env

# Crear un archivo .nvmrc (para la versión de nvm)
echo 'v18.15.0' > .nvmrc

# Crear un archivo .gitignore
echo '# Logs
logs
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*
pnpm-debug.log*
lerna-debug.log*

node_modules
dist
dist-ssr
*.local

# Editor directories and files
.vscode/*
!.vscode/extensions.json
.idea
.DS_Store
*.suo
*.ntvs*
*.njsproj
*.sln
*.sw?

.env' > .gitignore

# Crear un archivo .prettierrc.cjs
echo 'module.exports = {
  tabWidth: 2,
  arrowParens: "avoid",
  singleQuote: true,
  semi: false,
  trailingComma: "es5",
  bracketSpacing: true,
  endOfLine: "lf",
  // Por algún motivo, al setear printWidth: 100, en realidad te permite 101 lineas de largo
  printWidth: 99,
}' > .prettierrc.cjs

# Crea una carpeta client para el frontend
mkdir client
cd client

# Inicializa un nuevo proyecto npm
npm init -y

# Agrega las dependencias predeterminadas
npm install react react-dom react-router-dom -E
npm install -D -E @types/node @types/react @types/react-dom @typescript-eslint/eslint-plugin @typescript-eslint/parser @vitejs/plugin-react eslint eslint-config eslint-config-prettier eslint-plugin-css-import-order eslint-plugin-import eslint-plugin-prettier eslint-plugin-react eslint-plugin-react-hooks eslint-plugin-react-refresh prettier tailwindcss typescript typescript-eslint vite

# Agrega scripts personalizados al package.json, cambia el main y el name usando jq
jq --arg name "$PACKAGE_NAME" '.name = $name | .scripts += {
  "dev": "vite --host",
  "build": "tsc && vite build",
  "preview": "vite preview",
  "lint": "eslint . --fix",
  "format": "prettier --write \"**/*.{ts,tsx,js,md}\"",
  "type-check": "tsc --pretty --noEmit",
}' package.json > tmp.$$.json && mv tmp.$$.json package.json

# Crear un .eslintrc.json básico
echo '{
  "parser": "@typescript-eslint/parser",
  "plugins": ["react", "import", "prettier", "css-import-order"],
  "extends": [
    "eslint:recommended",
    "plugin:react/recommended",
    "plugin:@typescript-eslint/recommended",
    "plugin:css-import-order/recommended",
    "prettier"
  ],
  "env": {
    "es6": true,
    "browser": true,
    "jest": true,
    "node": true
  },
  "settings": {
    "react": {
      "version": "detect"
    }
  },
  "rules": {
    "react/display-name": "off",
    "react/jsx-no-duplicate-props": [1, { "ignoreCase": true }],
    "react/jsx-no-undef": 1,
    "react/jsx-pascal-case": [
      1,
      {
        "allowAllCaps": true,
        "ignore": []
      }
    ],
    "react/jsx-uses-react": 2,
    "react/jsx-uses-vars": 1,
    "react/no-deprecated": 1,
    "react/react-in-jsx-scope": 0,
    "react/jsx-no-useless-fragment": 1,
    "react/self-closing-comp": ["error"],
    "react/jsx-sort-props": [
      2,
      {
        "noSortAlphabetically": true,
        "reservedFirst": true,
        "callbacksLast": true,
        "ignoreCase": false
      }
    ],
    "@typescript-eslint/no-explicit-any": 1,
    "@typescript-eslint/no-var-requires": 0,
    "@typescript-eslint/no-unused-vars": [
      2,
      {
        "args": "after-used",
        "ignoreRestSiblings": false,
        "argsIgnorePattern": "^_"
      }
    ],
    "@typescript-eslint/no-non-null-assertion": "warn",
    "no-debugger": 2,
    "no-console": [
      2,
      {
        "allow": ["warn", "error"]
      }
    ],
    "no-var": 1,
    "import/no-extraneous-dependencies": "off",
    "import/order": [
      "error",
      {
        "groups": ["builtin", "external", "internal", ["parent", "sibling"]],
        "pathGroups": [
          {
            "pattern": "react",
            "group": "external",
            "position": "before"
          }
        ],
        "pathGroupsExcludedImportTypes": ["react"],
        "newlines-between": "always",
        "alphabetize": {
          "order": "asc",
          "caseInsensitive": true
        }
      }
    ],
    "no-restricted-syntax": [
      "error",
      {
        "selector": "ExportDefaultDeclaration",
        "message": "Exporting a default export is not supported. Use named export instead."
      }
    ],
    "no-await-in-loop": 1,
    "no-duplicate-imports": 2,
    "prettier/prettier": "error"
  },
  "ignorePatterns": [
    "**/*.js",
    "**/*.config.ts",
    "**/*.json",
    "node_modules",
    "public",
    "styles",
    ".next",
    "coverage",
    "dist"
  ]
}' > .eslintrc.json

# Crear un tsconfig.json básico
echo '{
  "compilerOptions": {
    "baseUrl": ".",
    "incremental": true,
    "target": "ES6",
    "lib": ["ESNext"],
    "experimentalDecorators": true,
    "emitDecoratorMetadata": true,

    "module": "CommonJS",
    "moduleResolution": "Node",
    "resolveJsonModule": true,

    "declaration": true,
    "sourceMap": true,

    "outDir": "./dist",
    "removeComments": true,

    "isolatedModules": false,
    "allowSyntheticDefaultImports": true,
    "esModuleInterop": true,
    "forceConsistentCasingInFileNames": false,

    "strict": true,
    "noImplicitAny": true,
    "strictNullChecks": true,
    "strictBindCallApply": true,
    "strictPropertyInitialization": true,
    "noFallthroughCasesInSwitch": true,

    "skipLibCheck": true,

    "types": ["node", "express"],

    "paths": {
      "src/*": ["src/*"]
    }
  },
  "include": ["src/**/**.ts", "index.ts"],
  "exclude": ["node_modules"]
}' > tsconfig.json


echo '/* eslint-disable no-console */
import { server } from "src/server"

const PORT = server.get("port")

server.listen(PORT, () => {
  console.log(`Servidor escuchando en puerto ${PORT}`)
})' > index.ts

mkdir src
cd src

echo 'import cors from 'cors'
import { configDotenv } from 'dotenv'
import express, { NextFunction, Request, Response } from 'express'
import logger from 'morgan'

configDotenv()

const { API_PORT, CLIENT_URL } = process.env

export const server = express()

server.use(
  cors({
    origin: CLIENT_URL,
    credentials: true,
  })
)

server.set('port', API_PORT || 4000)

server.use(logger('dev'))
server.use(express.json({ limit: '50mb' }))

server.use((err: Error, req: Request, res: Response, next: NextFunction) => {
  // @ts-expect-error Type Error does not include status
  const status = err.status || 500
  const message = err.message /* || err */ || 'Internal Server Error'
  console.error(err)
  res.status(status).send(message)
  next()
})' > server.ts

echo "Proyecto $PROJECT_NAME creado con éxito! 🤩🥳"
