/************************************************************************
**
** NAME:        imageloader.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Dan Garcia  -  University of California at Berkeley
**              Copyright (C) Dan Garcia, 2020. All rights reserved.
**              Justin Yokota - Starter Code
**				YOUR NAME HERE
**
**
** DATE:        2020-08-15
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <string.h>
#include "imageloader.h"

//Opens a .ppm P3 image file, and constructs an Image object. 
//You may find the function fscanf useful.
//Make sure that you close the file with fclose before returning.
Image *readData(char *filename) 
{
	//YOUR CODE HERE
	int i = 0;
	int j = 0;
	int col = 0;
	int row = 0;
	int range = 0;
	char buf[0x20] = {0};
	FILE *fp = fopen(filename, "r");
	fscanf(fp, "%s", buf);
	fscanf(fp, "%d %d", &col, &row);
	fscanf(fp, "%d", &range);
	Image *image = (Image *)malloc(sizeof(Image));
	image->cols = col;
	image->rows = row;
	image->image = (Color **)malloc(sizeof(Color *) * row);
	for(i = 0; i < row; i++){
		image->image[i] = (Color *)malloc(sizeof(Color) * col);
	}
	for(i = 0; i < row; i++){
		for(j = 0; j < col ; j++){
			fscanf(fp, "%3hhu %3hhu %3hhu", &image->image[i][j].R ,&image->image[i][j].G, &image->image[i][j].B);
		}
	}
	return image;
}

//Given an image, prints to stdout (e.g. with printf) a .ppm P3 file with the image's data.
void writeData(Image *image)
{
	//YOUR CODE HERE
	int col = image->cols;
	int row = image->rows;
	int i = 0;
	int j = 0;
	puts("P3");
	printf("%d %d\n", col, row);
	puts("255");
	for(i = 0; i < row; i++){
		for(j = 0; j < col - 1 ; j++){
			printf("%3hhu %3hhu %3hhu   ", image->image[i][j].R, image->image[i][j].G, image->image[i][j].B);
		}
		printf("%3hhu %3hhu %3hhu\n", image->image[i][j].R, image->image[i][j].G, image->image[i][j].B);
	}

}

//Frees an image
void freeImage(Image *image)
{
	//YOUR CODE HERE
	int i = 0;
	int row = image->rows;
	for(i = 0; i < row; i++){
		free(image->image[i]);
		image->image[i] = 0;
	}
	free(image->image);
	image->image = 0;
	image->cols = 0;
	image->rows = 0;
	free(image);
	image = 0;
}