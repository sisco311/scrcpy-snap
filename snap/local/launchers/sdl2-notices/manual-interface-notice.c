/*
    Simple SDL2 application to display a notice with a timeout

    SPDX-License-Identifier: Apache-2.0
    Copyright 2025 Buo-ren Lin <buo.ren.lin@gmail.com>
*/
#include <SDL2/SDL.h>
#include <SDL2/SDL_ttf.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <time.h>

#define WINDOW_WIDTH 1280
#define WINDOW_HEIGHT 720
#define FONT_SIZE 36
#define TIMEOUT 60

const char *notice_template = "The following functionality requires the \"raw-usb\" snapd security confinement interface to be connected:\n\nOTG mode\n\nYou may do so by running the following command in a terminal:\n\n    sudo snap connect scrcpy:raw-usb\n\nPress ENTER to continue or press Q within %u seconds to quit.";

int main(int argc, char *argv[]) {
    int needed = snprintf(NULL, 0, notice_template, TIMEOUT);

    /*
        The snprintf function returns the number of characters that would have been written if enough space had been available.
        The +1 is to account for the null terminator.
    */
    needed = needed + 1;

    char *notice = malloc(needed);
    snprintf(notice, needed, notice_template, TIMEOUT);

    if (SDL_Init(SDL_INIT_VIDEO) != 0) {
        fprintf(stderr, "SDL_Init Error: %s\n", SDL_GetError());
        return 1;
    }
    if (TTF_Init() != 0) {
        fprintf(stderr, "TTF_Init Error: %s\n", TTF_GetError());
        SDL_Quit();
        return 1;
    }

    SDL_Window *win = SDL_CreateWindow(
        "Notice", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
        WINDOW_WIDTH, WINDOW_HEIGHT, SDL_WINDOW_SHOWN
    );
    if (!win) {
        fprintf(stderr, "SDL_CreateWindow Error: %s\n", SDL_GetError());
        TTF_Quit();
        SDL_Quit();
        return 1;
    }

    SDL_Renderer *ren = SDL_CreateRenderer(win, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);
    if (!ren) {
        fprintf(stderr, "SDL_CreateRenderer Error: %s\n", SDL_GetError());
        SDL_DestroyWindow(win);
        TTF_Quit();
        SDL_Quit();
        return 1;
    }

    char *font_path = NULL;
    char *snap_path = getenv("SNAP");
    if (!snap_path) {
        font_path = "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf";
    } else {
        const char *font_path_template = "%s/gnome-platform/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf";
        int font_path_needed = snprintf(NULL, 0, font_path_template, snap_path);
        font_path = malloc(font_path_needed + 1);
        snprintf(font_path, font_path_needed + 1, font_path_template, snap_path);
    }
    TTF_Font *font = TTF_OpenFont(font_path, FONT_SIZE);
    if (snap_path) {
        free(font_path);
    }
    if (!font) {
        fprintf(stderr, "TTF_OpenFont Error: %s\n", TTF_GetError());
        SDL_DestroyRenderer(ren);
        SDL_DestroyWindow(win);
        TTF_Quit();
        SDL_Quit();
        return 1;
    }

    SDL_SetRenderDrawColor(ren, 240, 240, 240, 255);
    SDL_RenderClear(ren);

    SDL_Rect rect = {40, 40, 1200, 640};
    SDL_SetRenderDrawColor(ren, 200, 200, 200, 255);
    SDL_RenderFillRect(ren, &rect);

    SDL_Color textColor = {0, 0, 0, 255};
    SDL_Surface *textSurface = TTF_RenderUTF8_Blended_Wrapped(font, notice, textColor, rect.w - 20);
    if (textSurface) {
        SDL_Texture *textTexture = SDL_CreateTextureFromSurface(ren, textSurface);
        if (textTexture) {
            SDL_Rect textRect = {rect.x + 10, rect.y + 10, textSurface->w, textSurface->h};
            SDL_RenderCopy(ren, textTexture, NULL, &textRect);
            SDL_DestroyTexture(textTexture);
        }
        SDL_FreeSurface(textSurface);
    }
    free(notice);

    SDL_RenderPresent(ren);

    bool timeout = false;
    bool running = true;
    bool bail = false;
    time_t start = time(NULL);
    SDL_Event e;
    while (running) {
        while (SDL_PollEvent(&e)) {
            if (e.type == SDL_QUIT) {
                bail = true;
                running = false;
            }
            if (e.type == SDL_KEYDOWN && e.key.keysym.sym == SDLK_RETURN) running = false;
            if (e.type == SDL_KEYDOWN && e.key.keysym.sym == SDLK_q) {
                bail = true;
                running = false;
            }
        }
        if (time(NULL) - start > TIMEOUT) {
            timeout = true;
            break;
        }
        SDL_Delay(50);
    }

    TTF_CloseFont(font);
    SDL_DestroyRenderer(ren);
    SDL_DestroyWindow(win);
    TTF_Quit();
    SDL_Quit();

    if (bail) {
        return 1;
    } else {
        if (timeout) {
            return 2;
        }
        return 0;
    }
}
