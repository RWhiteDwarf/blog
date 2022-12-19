---
author: "Manuel Teodoro Tenango"
title: "Using Emacs for R"
image: ""
draft: true
date: 2022-12-07
description: " "
tags: ["R basics", "R tips", "emacs"]
categories: ["R"]
archives: ["2022"]
---



## Title intro

To start using R, or almost anything else in Emacs, you basically need to know 3 things: 1) How to move in Emacs, meaning understanding what is what and learning a few key commands; 2) What is the configuration file and how to use it and 3) How to use packages to extend Emacs. In the first half of this post I will try to show how easy it is to cover these 3 points even for people who are inexperienced in programming. If you don't believe me I invite you to read just the first paragraph of the next section to give you an idea of how easy it really is. During the second half I will show how I'm using R in Emacs to give you a starting point of a fully functional environment for R, and will conclude with some topics that can be further explored. 

## Why did I chose Emacs as a researcher in the academia?

I started my professional life as a researcher in ecology-related topics. During my master studies I improved my knowledge on statistics considerably and due to that and to the complexity of my research project, I did not want to use a GUI-based software for my statistical analysis. Thus, I started learning R, and believe it or not, I completed my research project for my Thesis by tipping R code directly to the console from my handwritten notes. When I started my PhD I thought that it would be easier to just write the code I need in electronic format and copy-paste it to the R console. And with that idea in mind and the help of the internet, I discovered the text editors and Emacs, and a whole new universe opened up to me. I know that many in my position would be ashamed of sharing such a story but I simply want to exemplify how easy it is to start using Emacs, contrary to the popular belief. I went from having no idea of what a text editor is, to setting up and using Emacs with R, with no intermediate steps.

Emacs is a wonderful text editor that can easily be extended to do many things. You can have tools to help in writing your code such as different types of indentation, syntax highlighter, git utilities, project management, code maps, web browser, even play games. --->**Describe more as a developer**<---

The reason why I stayed with Emacs as a researcher in the academia was mainly due to org-mode. It is an Emacs major mode that helped me to organize my research and in still today it helps me to organize my job. You can think if it as the Emacs version of Markdown, with the possibility to organize to do lists, tag notes and sections, fully organize an agenda (tracking tasks, set deadlines, schedule items, etc.). You can add chunks of code from almost any language and, with the help of couple more library, you can run the code within the org file itself. Github and other git servers have integrated tools to view org files as html, but there are libraries to convert them also to pdf, libreoffice, create presentations and more. 

Another important point that made me fall in love with Emacs was the fact that, if I managed to keep most of my research files as text I could do it all from Emacs, instead of using different apps for different tasks. And so I did: I was writing my papers in LaTeX and organizing my bibliography with bibtex; I was saving data as CSV which Emacs can manage very well; the graphics were more of an issue but, since I used R to make most of it, I simply needed to save the right script for the right plot. And all this was organized in org-mode with links to this or that file according to the project, section, tag, etc. And the reason why I wanted to do this was not even for organization purposes, but rather because, as text, I could track all my changes using Git, with ended up being a huge support for my PhD work: I could revert changes if I had mistakes or explore old commits, and backup all of that easily. So, at the end, while R had been the reason why I decided to explore Emacs, it was in fact the combo Emacs + org-mode + git which improved my organization and productivity potentially during my research life. And I would like to share this tools with as many people as possible.

Thus, I decided to create this post to give you an idea of how easily you can start using Emacs for R coding. If you enjoy it and you'd like me to create more detail posts about some of the tools I describe here leave me a comment and I'll take care of it. I include a general list of the tools I use regularly in Emacs at the end, you can have a look there.

## Quick start 

Although Emacs is extremely customizable, it is true that it requires some coding skills and knowledge of the not so popular programming language called Emacs Lisp. You would probably have also read that Emacs has a very steep learning curve, which is also true. This two conditions usually scare people away from learning Emacs. In this section I will demonstrate that you don't need to know Emacs Lisp (or programming at all) and that with very little knowledge of Emacs you can have a ready-to-use super-powerful R editor.

This chapter is a brief overview of the rest of the post meant as a quick start to get Emacs up and working with R in just as few as 10 steps. The rest of the post will simply go deeper into each of the steps. 

 1. Make sure that you have installed both, Emacs and R in your computer.
 
 2. Open Emacs and press the keys Ctr + x, release and press Ctr + f (in Emacs notation, this combination of keys is expressed as "**C-x C-f**"). Focus on the **mini buffer**, it is the line positioned at the bottom of your window. It is waiting for you to type something. If there is some path to a folder already in that area delete it first and then type `~/.emacs` and enter. It should open a new empty window.
 
 ---> Image of modeline <---
 
 3. This is your configuration file. Paste the following code in your new window 
 
```{emacs-lisp emacs_init}
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(package-initialize)


(eval-when-compile 
  (add-to-list 'load-path "~/.emacs.d/elpa/")
  (require 'use-package))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(setq use-package-always-ensure t)

(use-package ess)

(use-package company
  :config
  (add-hook 'after-init-hook 'global-company-mode))

(setq company-selection-wrap-around t
      company-tooltip-align-annotations t
      company-idle-delay 0.45
      company-minimum-prefix-length 3
      company-tooltip-limit 10)
```

This configuration assumes that you have installed R with all the defaults. If you have installed R in a directory of your choice, add the following line at the end of the configuration file, changing the path of my example for the path were you have installed R. 

```{emacs-lisp path_r}
(setq inferior-ess-r-program "C:/Users/Manuel/path_where_R_is/R-4.2.1/bin/R.exe")
```

 4. Type **C-x C-s** (meaning, Ctr + x, release, Ctr + s). This will save the file. 
 
 5. Type now Alt + x (in Mac *command* key instead of Alt or, if it does not work, the *option* key instead), this is the key Meta, represented in Emacs by **M-x**. At this point you want to focus again on your mini buffer, the line at the bottom of the screen.
 
 6. Type there `package-install` enter and then type `use-package`, enter. 
 
 7. Focus on the mini buffer in case it prompts something. If it asks you if you want to install the package type `y` and enter. If it tells you that it cannot find the package or it does not exist, close Emacs, open it again and repeat steps 5 and 6. It should show a message informing that it has been installed. 
 
 ---> image example <---
 
 8. Now close Emacs and open it again.
 
 9. Type again **C-x C-f** and type `test.R`, enter. You can change the path before the file if you wish (i.e. `~/Code/test.R`).
 
 10. A new empty area should appear. Type there one line of R code. When you are done, while keeping the cursor in the line where your code is, press **C-c C-j**, this sends a line to R. A new area will open, showing the R console and the results of the code you just sent. You can continue typing R code and use the same combination of keys to run a line, you can use **C-c C-p** to run a paragraph, **C-c C-f** to send a function and **C-c C-b** the send the whole buffer (which here basically means the whole file). You can save the file by pressing **C-x C-s**. 
 
 ---> screenshot <---
 
If everything went well now you should have a simple Emacs configuration to start coding in R. Congratulations!.

## Getting started with Emacs

### Installation and first steps

Both, R and Emacs are extremely easy to install, therefore I will not use many words to describe the process. In basically any Linux distribution you can just use your package manager for it, in windows just download and run the official executable files and for Mac you can also download the binaries or use alternative package methods like homebrew (also applicable for Linux). For R go to (https://www.r-project.org/) and for Emacs to (https://www.gnu.org/software/emacs/).

Once you have installed Emacs you can run it and you will have the welcome screen, together with some toolbars and list of menus. At this point you could basically use Emacs like any other software: you can open files, edit them and save them by using all the menus, icons and your mouse. However, the real power of Emacs rest in its keybindings. To get started I recommend to click on the link **Emacs Tutorial** of the welcome screen, it will guide you through the basics. After the tutorial you will feel more comfortable finding your way around Emacs and the rest of this post will be easier to follow.

--->**Emacs welcome screenshot**<---

### Control, Meta and the minibuffer, moving in Emacs

When you are working with text most of the time (as it is the case of R code) the use of the mouse can reduce productivity by searching with your eyes the exact places you want to mark, going all the way to the menu to save or open a file, finding when a parentheses opens and closes, and so on. The idea of the keybindings is to increase productivity by staying in the text at the level of the keyboard most of the time, since this is what we actually do when we write code.

At the beginning it can be complicated to memorize so many keybindings. I'd recommend to try to remember the most basic ones to move along the text, save files, close Emacs and split the screen as you need to. The rest can be easily achieved through the mouse icons and menus. I was having a piece of paper with the most useful keybindings and, as my fingers started remembering by themselves I was deleting those and adding new ones. Today I can assure you that my productivity to write R code is much better than it ever was with any other text editor. 

I will not go through the details of which keybindings do what since it is all in the self contained tutorial, however there are some key points to learn the keybindings. One is the knowledge of the so called "Emacs Notation". Whenever you search either in Emacs documentation or some other sources to use Emacs, how to perform certain actions, you will find things like **C-M-a**. The capital `C` is short for the key Control, while capital `M` is for meta, which in most computers is Alt and in Mac is usually command. Thus, **C-M-a** would mean that you have to hold the key __Control__, the key __Meta__ and the key __a__. Usually the keys Control and Meta are used in combination with other keys and thus, the letters **C** and **M** are used at the beginning of the commands. That would mean that, for example, the combination **C-C** does not mean Control twice, but rather Control plus capital C. Although this rarely happens (I've never used such a combination), it is important to be aware because Emacs recognizes difference between upper and lower case. 

--->**Emacs minibuffer screenshot**<---

Another important part to know in Emacs is the minibuffer. By default it is positioned at the bottom of the screen and it is used to communicated commands between Emacs and the user. For example, when you save a file the minibuffer will print something like `Wrote /path/to/file.R` to signal that the file has been saved. 

The minibuffer is also used to pass commands to Emacs. All the keybindings are bind to a command, although not every command is bind to a key. To pass a command to Emacs you can use the keys **M-x**. As an example you can try to use **M-x** and you will see that the minibuffer has changed and now is ready to receive your input. Type there `help-for-help` and a new menu will appear, showing you the options for help and the instructions to use it. For example, type **b** to display all keybindings. The command `help-for-help` is bind to the keys **C-h ?** therefore, if you would time this combination instead you would have the same response.

Emacs uses intuitive key bindings and thus, the combination **C-h** is designed for **h**elp. For example, the combination **C-h b** will show the help for the bindings, **C-h t** help with tutorial, **C-h f** help for a function (you have to type in the function), etc. **C-x** executes high levels functions such as **s**ave file **C-x C-s** or **c**lose Emacs with **C-x C-c**.

You can take some time to familiarize yourself with some of the keybindings and later you will see how it pay off when writing an executing R code. 

### The configuration file

The second part of the power of Emacs is its customization. The first aspect for its customization is the init file, also known as dot Emacs. According to its documentation:

> When Emacs is started, it normally tries to load a Lisp program from an initialization file, or init file for short. This file, if it exists, specifies how to initialize Emacs for you. Traditionally, file `~/.emacs` is used as the init file, although Emacs also looks at `~/.emacs.el`, `~/.emacs.d/init.el`, `~/.config/emacs/init.el`, or other locations. See [How Emacs Finds Your Init File](https://www.gnu.org/software/emacs/manual/html_node/emacs/Find-Init.html).

This means that you have several options to tell Emacs how to start. If you are not familiar with Unix style, `~/` is the home directory. That means that you can have your configuration file in your home directory called `.emacs` or `.emacs.el`, or you can have it inside a configuration folder `~/.emacs.d/` or `~/.config/emacs/` with the name `init.el` (or some other options, see the link in the quote). 

To keep consistency and facility, we will keep the same approach that we used in the quick guide above and use the file dot emacs.

> 2. Open Emacs and press the keys Ctr + x, release and press Ctr + f (in Emacs notation, this combination of keys is expressed as "**C-x C-f**"). Focus on the **mini buffer**, it is the line positioned at the bottom of your window. It is waiting for you to type something. If there is some path to a folder already in that area delete it first and then type `~/.emacs` and enter. It should open a new empty window.

If you followed step 2 from Emacs you should have now an empty screen where you can start typing Elisp code to tell Emacs how to start. The file still does not exists but wit the command **C-x C-f** we are creating it. Make sure that it is store in the home folder `~/` and not somewhere else. To demonstrate the point type the following line in your new file: `(setq inhibit-startup-screen t)`, that tells Emacs to inhibit the startup screen. Now save it with **C-x C-s**, close Emacs and open it again and now the startup screen showing you the tutorial should not be there anymore. If you still want to see the welcome screen at startup you can simply delete that line and the startup screen will be back (**C-x C-f** type `~/.emacs`, delete the line and save). 

Here are just couple of lines that are useful to add to your dot Emacs file for writing R code:

```{emacs-lisp dot-emacs}
;; enable column numbers
(setq column-number-mode t)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; Using arrow for moving through buffers
(global-set-key (kbd "C-x <up>") 'windmove-up)
(global-set-key (kbd "C-x <down>") 'windmove-down)
(global-set-key (kbd "C-x <left>") 'windmove-left)
(global-set-key (kbd "C-x <right>") 'windmove-right)

;; Starting file
(setq initial-buffer-choice
      (lambda ()
	(if (buffer-file-name)
	    (current-buffer)
	  (find-file "~/Path/to_your_file/a_starting_file.R"))))
```

The first part will simply enable column numbers when writing code, for some reason Emacs does not do it by default. The second paragraph will allow you to move between buffers using **C-x** and the arrows. For example, you can split buffer horizontally using **C-x 2** and then move to the lower buffer using **C-x** and down arrow, or back to the upper with the upper arrow **C-x <up>**. The last part can set a custom starting file, meaning each time you open Emacs this will be the file that will open by default, but if you open a file with Emacs this file won't show up. 

### Extending Emacs: packages

Emacs can be fully customized in the sense that you can write Elisp code to get Emacs do what you want. Luckily, you don't need to know Elisp to take advantage of it. Like in R, there are several packages that extend the basic Emacs to do more than it was originally designed to. In the quick start section steps 3 to 7 we did exactly that in 2 different ways. Let's take a look at each option and detail to install packages.

#### Melpa 

#### list-packages and install-package

#### use-package


## ESS to speak with R

### What is ESS?

### How to use R in ESS

### Other useful add-ins for R productivity

## What next? - Explore Emacs libraries