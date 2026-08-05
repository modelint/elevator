# The Elevator Case Study

I designed the Elevator Case Study as a teaching example to use in my systems engineering and modeling classes, and I reference it throughout the Blueprint modeling tool documentation. I wanted an example more complicated and real-world than the usual toy examples I often see in tool demos. At the same time, I keep the functionality basic so we can focus on the principles. And I chose an elevator application so that you can spend more time on the modeling lessons and not so much on learning a new system. Many of us have experience interacting with such systems in our daily lives. But, yes, I know (and hope) you are working on something far more complex, challenging, and potentially hazardous than this!

I also challenge my clients and students to think about how they would build this system differently, especially with the incorporation of AI. I do have a video lesson in the works on my YouTube channel where I point out some key modeling decisions that take AI into account.

So this case study is for education, tool demos, and as an architectural punching bag to contrast large and small scale modeling decisions.

## Start with the wiki

The [wiki](https://github.com/modelint/elevator/wiki) walks you through each of the domains and models class by class and relationship by relationship, with the diagrams rendered for reading. This repository manages the underlying model source.

## What's in this repository

The models are text, not tool binaries. Every diagram you see is generated from those text files rather than drawn by hand, so the model source is the thing under version control and the PDFs are build products committed alongside it for convenient reading.

`system/system.yaml` names the domains and is the place to start:

- **Elevator Management** — the application domain, modeled in full
- **User Interface**, **Transport**, **Signal IO** — service domains, specified only at the boundary where Elevator Management meets them

Under `system/elevator-management/elevator/` you will find the class model, a state machine for each class with a lifecycle, the class methods, and an `external/` specification of the events and operations that cross the domain boundary. `technical-notes/` holds the write-ups of the floor search and bank selection algorithms.

## License

MIT — see [LICENSE](LICENSE). Use it in your own teaching or tool demos.