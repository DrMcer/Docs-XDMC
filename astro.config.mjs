// @ts-check
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

export default defineConfig({
	integrations: [
		starlight({
			title: {
				en: 'Docs',
				zh: 'Docs'
			},
			favicon: '/images/favicon.png',
			logo: {
				src: './src/assets/xducraft.png',
				alt: 'XDUCraft'
			},
			tableOfContents: false,
			description: '这是一个存放XDUCraft各种技术文档的网站',
			customCss: ['./src/styles/custom.css'],
			components: {
				SocialIcons: './src/components/SocialIcons.astro',
				SiteTitle: './src/components/SiteTitle.astro',
				Sidebar: './src/components/Sidebar.astro'
			},
			editLink: {
				baseUrl: 'https://github.com/Unda-Rubra/Docs-XDMC/edit/main/'
			},
			sidebar: [
				{
					label: '总览',
					items: [
						{ label: '总览页面', slug: 'general/intro'}
					],
				},
				{
					label: 'XDUCraft 入门图文教程',
					autogenerate: { directory: 'join-server'}
				},
				{
					label: '整合包食用指南',
					items: [
						{ label: '整合包食用指南', slug: 'modpack_tutorial'}
					]
				},
				{
					label: '粘液科技基础-进阶附属教程讲解',
					items: [
						{ label: '粘液科技基础-进阶附属教程讲解', slug: 'slimefun'}
					]
				},
				{
					label: '开服教程（JAVA版）',
					autogenerate: { directory: 'server-setup'}
				},
				{
					label: 'Terraria服务器须知',
					items: [
						{ label: 'Terraria服务器须知', slug: 'terraria'}
					]
				}
			],
		}),
	],
});
