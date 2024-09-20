import type * as Preset from "@docusaurus/preset-classic";
import type { Config } from "@docusaurus/types";
import { themes as prismThemes } from "prism-react-renderer";

const config: Config = {
	title: "UCS Contracts",
	tagline: "A flexible and upgradeable smart contract architecture.",
	favicon: "img/favicon.ico",

	url: "https://ucs.ecdysis.xyz",
	baseUrl: "/",

	organizationName: "ecdysisxyz",
	projectName: "ucs-contracts",

	onBrokenLinks: "warn",
	onBrokenMarkdownLinks: "warn",

	i18n: {
		defaultLocale: "en",
		locales: ["en"],
	},

	presets: [
		[
			"classic",
			{
				docs: {
					path: "../docs",
					routeBasePath: "/",
					sidebarPath: require.resolve("./sidebars.ts"),
					editUrl: "https://github.com/ecdysisxyz/ucs-contracts/tree/main/book",
				},
				theme: {
					customCss: "./src/css/custom.css",
				},
			} satisfies Preset.Options,
		],
	],

	markdown: {
		mermaid: true,
		format: "detect",
	},
	themes: ["@docusaurus/theme-mermaid"],

	themeConfig: {
		image: "img/ecdysis-logo.png",
		navbar: {
			title: "UCS Contracts",
			logo: {
				alt: "Ecdysis Logo",
				src: "img/ecdysis-logo.png",
			},
			items: [
				{
					html: "Overview",
					to: "/overview",
					position: "left",
				},
				{
					html: "Proxy",
					to: "/proxy",
					position: "left",
				},
				{
					html: "Dictionary",
					to: "/dictionary",
					position: "left",
				},
				{
					href: "https://github.com/ecdysisxyz/ucs-contracts",
					label: "GitHub",
					position: "right",
				},
			],
		},
		footer: {
			style: "dark",
			links: [
				{
					title: "Docs",
					items: [
						{
							label: "Overview",
							to: "/overview",
						},
						{
							label: "Proxy",
							to: "/proxy",
						},
						{
							label: "Dictionary",
							to: "/dictionary",
						},
					],
				},
				{
					title: "Community",
					items: [
						{
							label: "Stack Overflow",
							href: "https://stackoverflow.com/questions/tagged/ucs",
						},
						{
							label: "X",
							href: "https://x.com/ecdysis_xyz",
						},
					],
				},
				{
					title: "More",
					items: [
						{
							label: "GitHub",
							href: "https://github.com/ecdysisxyz/ucs-contracts",
						},
					],
				},
			],
			copyright: `Copyright © ${new Date().getFullYear()} Ecdysis, Inc. Built with Docusaurus.`,
		},
		prism: {
			theme: prismThemes.github,
			darkTheme: prismThemes.dracula,
			additionalLanguages: ["solidity"],
		},
	} satisfies Preset.ThemeConfig,
};

export default config;
