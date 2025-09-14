/************************************************************************
**
** NAME:        steganography.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Dan Garcia  -  University of California at Berkeley
**              Copyright (C) Dan Garcia, 2020. All rights reserved.
**				Justin Yokota - Starter Code
**				YOUR NAME HERE
**
** DATE:        2020-08-23
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "imageloader.h"

//Determines what color the cell at the given row/col should be. This should not affect Image, and should allocate space for a new Color.
Color *evaluateOnePixel(Image *image, int row, int col)
{
	//YOUR CODE HERE
	uint8_t blue = image->image[row][col].B;
	Color * color = (Color*)malloc(sizeof(Color));
	color->R = (blue & 1) * 255;
	color->G = (blue & 1) * 255;
	color->B = (blue & 1) * 255;
	return color;
}

//Given an image, creates a new image extracting the LSB of the B channel.
Image *steganography(Image *image)
{
	//YOUR CODE HERE
	int i = 0;
	int j = 0;
	int col = 0;
	int row = 0;
	Color* color = NULL;
	col = image->cols;
	row = image->rows;
	Image *image_re = (Image *)malloc(sizeof(Image));
	image_re->cols = col;
	image_re->rows = row;
	image_re->image = (Color **)malloc(sizeof(Color *) * row);
	for(i = 0; i < row; i++){
		image_re->image[i] = (Color *)malloc(sizeof(Color) * col);
	}
	for(i = 0; i < row; i++){
		for(j = 0; j < col ; j++){
			color = evaluateOnePixel(image, i, j);
			image_re->image[i][j].R = color->R;
			image_re->image[i][j].G = color->G;
			image_re->image[i][j].B = color->B;
			free(color);
			color = NULL;
		}
	}
	return image_re;
}

/*
Loads a file of ppm P3 format from a file, and prints to stdout (e.g. with printf) a new image, 
where each pixel is black if the LSB of the B channel is 0, 
and white if the LSB of the B channel is 1.

argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename, containing a file of ppm P3 format (not necessarily with .ppm file extension).
If the input is not correct, a malloc fails, or any other error occurs, you should exit with code -1.
Otherwise, you should return from main with code 0.
Make sure to free all memory before returning!
*/
int main(int argc, char **argv)
{
	//YOUR CODE HERE
	if(argc != 2){
		exit(-1);
	}
	char* filename = argv[1];
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

	Image* image_re = steganography(image);
	col = image_re->cols;
	row = image_re->rows;
	puts("P3");
	printf("%d %d\n", col, row);
	puts("255");
	for(i = 0; i < row; i++){
		for(j = 0; j < col - 1 ; j++){
			printf("%3hhu %3hhu %3hhu   ", image_re->image[i][j].R, image_re->image[i][j].G, image_re->image[i][j].B);
		}
		printf("%3hhu %3hhu %3hhu\n", image_re->image[i][j].R, image_re->image[i][j].G, image_re->image[i][j].B);
	}

	
	row = image->rows;
	for(i = 0; i < row; i++){
		free(image->image[i]);
		image->image[i] = 0;
	}
	free(image->image);
	image->image = 0;
	image->cols = 0;
	image->rows = 0;
	free(image);

	row = image_re->rows;
	for(i = 0; i < row; i++){
		free(image_re->image[i]);
		image_re->image[i] = 0;
	}
	free(image_re->image);
	image_re->image = 0;
	image_re->cols = 0;
	image_re->rows = 0;
	free(image_re);

}
