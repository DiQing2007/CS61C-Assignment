/************************************************************************
**
** NAME:        gameoflife.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Justin Yokota - Starter Code
**				YOUR NAME HERE
**
**
** DATE:        2020-08-23
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "imageloader.h"

//Determines what color the cell at the given row/col should be. This function allocates space for a new Color.
//Note that you will need to read the eight neighbors of the cell in question. The grid "wraps", so we treat the top row as adjacent to the bottom row
//and the left column as adjacent to the right column.
Color *evaluateOneCell(Image *image, int row, int col, uint32_t rule)
{
	//YOUR CODE HERE
	int i = 0;
	int j = 0;
	int is_alive = 0;
	int is_dead = 0;
	int tmp = 0;
	int tmp1=0;
	int tmp2=0;
	int rows = image->rows;
	int cols = image->cols;
	int flag = 0;
	int is_flip_alive = 0;
	uint16_t live = (rule >> 9) & 0b111111111;
	uint16_t dead = rule & 0b111111111;
	uint16_t check = 0;
	uint8_t blue  = image->image[row][col].B;
	uint8_t red   = image->image[row][col].R;
	uint8_t green = image->image[row][col].G;
	Color * color = (Color*)malloc(sizeof(Color));
	//if((!blue) == 0 && (!red) ==0 && (!green) == 0){
	if(red == 255){
		flag = 1;
	}
	if(flag){
		check = live;
	}
	else{
		check = dead;
	}
	for(i = 0; i<3; i++){
		for(j = 0;j<3; j++){
			if(i == 1 && j == 1){
				continue;
			}
			tmp = image->image[(row - 1 + i + rows) % rows ][(col - 1 + j + cols) % cols].B;
			tmp1 = image->image[(row - 1 + i + rows) % rows ][(col - 1 + j + cols) % cols].G;
			tmp2 = image->image[(row - 1 + i + rows) % rows ][(col - 1 + j + cols) % cols].R;
			if( tmp2 !=255 ){
				is_dead++;
			}
			else{
				is_alive++;
			}
		}
	}
	if(flag){
		is_flip_alive = !!((1 << is_alive) & check);
	}
	else{
		is_flip_alive = !!((1 << is_alive) & check);
	}
	if(is_flip_alive){
		color->R = 0b11111111;
		color->G = 0b11111111;
		color->B = 0b11111111;
	}
	else{
		color->R = 0b0;
		color->G = 0b0;
		color->B = 0b0;
	}
	
	return color;
}

//The main body of Life; given an image and a rule, computes one iteration of the Game of Life.
//You should be able to copy most of this from steganography.c
Image *life(Image *image, uint32_t rule)
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
			color = evaluateOneCell(image, i, j, rule);
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
Loads a .ppm from a file, computes the next iteration of the game of life, then prints to stdout the new image.

argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename, containing a .ppm.
argv[2] should contain a hexadecimal number (such as 0x1808). Note that this will be a string.
You may find the function strtol useful for this conversion.
If the input is not correct, a malloc fails, or any other error occurs, you should exit with code -1.
Otherwise, you should return from main with code 0.
Make sure to free all memory before returning!

You may find it useful to copy the code from steganography.c, to start.
*/
int main(int argc, char **argv)
{
	//YOUR CODE HERE
	char *magic = argv[2];
	uint32_t rule = (uint32_t)strtol(magic, NULL, 0);
	char * filename = argv[1];
	Image *image =  readData(filename);
	Image *result = life(image, rule);
	writeData(result);
	freeImage(image);
	freeImage(result);


}
