enum code_ops {START,HALT, LD_INT_VALUE, STORE, WRITE_INT, LD_VAR, ADD, SUB, MUL, DIV, LD_INT, LTN, LTNE, GTN, GTNE, EQ, NEQ, JMP_FALSE, JMP_TRUE, GOTO, LABEL};

char *op_name[] = {"start", "halt", "ld_int_value", "store", "write_int", "ld_var", "add","sub","mul","div", "ld_int", "lt", "lte", "gt", "gte", "eq","neq", "jmp_false", "jmp_true", "goto", "label"};

struct instruction
{
    enum code_ops op;
    int arg;
};

struct instruction code[999];

int code_offset = 0;

void gen_code(enum code_ops op, int arg)
{
    code[code_offset].op = op;
    code[code_offset].arg = arg;
    
    code_offset++;
}

void print_code()
{
    int i = 0;

    for(i=0; i<code_offset; i++)
    {
        printf("%3d: %-15s  %4d\n", i, op_name[code[i].op], code[i].arg);

    }
}

void print_assembly()
{
    int i = 0;

	FILE* fp = freopen("assembly.s","w+",stdout);

    for(i=0; i<code_offset; i++)
    {
        printf("\n#%s\n", op_name[code[i].op]);

        switch(code[i].op)
        {
            case START:
                            printf(".text\n");
                            printf(".globl main\n");
                            printf("main:\n");
                            // printf("addiu $t7, $sp, 160\n");
                            printf("addiu $t7, $sp, 600\n");

                            break;

            case HALT:
                            printf("li $v0, 10\n");
                            printf("syscall\n");
							fclose(fp);
                            break;
            
            case LD_INT_VALUE:
                            printf("li $a0, %d\n", code[i].arg);
                            break;

            case STORE:
                            printf("sw $a0, %d($t7)\n", 16*code[i].arg);
                            break;

            case WRITE_INT:
                            printf("lw $a0, %d($t7)\n", 16*code[i].arg);
                            printf("li $v0, 1\n");
                            printf("move $t0, $a0\n");
                            printf("syscall\n");
							// printf("addi $a0, $0, 0xA\n");				
							// printf("addi $v0, $0, 0xB\n");
							// printf("syscall\n");
                            break;
            
            case LD_VAR    : 
                            printf("lw $a0, %d($t7)\n", 16*code[i].arg);
                            printf("sw $a0, 0($sp)\n");
                            printf("addiu $sp, $sp, 16\n");
                            printf("\n");
                            break;

            case LD_INT    :
                            printf("li $a0, %d\n", code[i].arg);
                            printf("sw $a0, 0($sp)\n");
                            printf("addiu $sp, $sp, 16\n");
                            printf("\n");
                            break;

            case ADD       :
                            printf("addiu $sp, $sp, -16\n");
                            printf("lw $a0, 0($sp)\n");
                            printf("addiu $sp, $sp, -16\n");
                            printf("lw $t1, 0($sp)\n");
                            printf("add $a0, $t1, $a0\n");
                            printf("sw $a0, 0($sp)\n");
                            printf("addiu $sp, $sp, 16\n");
                            printf("\n");
                            break;
							
			case SUB       :
                            printf("addiu $sp, $sp, -16\n");
                            printf("lw $a0, 0($sp)\n");
                            printf("addiu $sp, $sp, -16\n");
                            printf("lw $t1, 0($sp)\n");
                            printf("sub $a0, $t1, $a0\n");
                            printf("sw $a0, 0($sp)\n");
                            printf("addiu $sp, $sp, 16\n");
                            printf("\n");
                            break;

			case MUL		:
							printf("addiu $sp, $sp, -16\n");
                            printf("lw $a0, 0($sp)\n");
                            printf("addiu $sp, $sp, -16\n");
                            printf("lw $t1, 0($sp)\n");
                            printf("mul $a0, $t1, $a0\n");
                            printf("sw $a0, 0($sp)\n");
                            printf("addiu $sp, $sp, 16\n");
                            printf("\n");
							break;

			case DIV		:
							printf("addiu $sp, $sp, -16\n");
                            printf("lw $a0, 0($sp)\n");
                            printf("addiu $sp, $sp, -16\n");
                            printf("lw $t1, 0($sp)\n");
                            printf("div $a0, $t1, $a0\n");
                            printf("sw $a0, 0($sp)\n");
                            printf("addiu $sp, $sp, 16\n");
                            printf("\n");
							break;
            case JMP_FALSE: printf("beq $a0, 0, LABEL%d\n", code[i].arg);
                            printf("\n");
                            break;
			case JMP_TRUE:  printf("beq $a0, 1, LABEL%d\n", code[i].arg);
                            printf("\n");
                            break;				

            case GOTO: printf("b LABEL%d\n", code[i].arg);
                            printf("\n");
                            break;
            
            case LTN    :
                            printf("addiu $sp, $sp, -16\n");
                            printf("lw $a0, 0($sp)\n");
                            printf("addiu $sp, $sp, -16\n");
                            printf("lw $t1, 0($sp)\n");
                            printf("slt $a0, $t1, $a0\n");
                            printf("sw $a0, 0($sp)\n");
                            printf("add $sp, $sp, 16\n");
                            printf("\n");
                            break;
			case LTNE    :
                            printf("addiu $sp, $sp, -16\n");
                            printf("lw $a0, 0($sp)\n");
                            printf("addiu $sp, $sp, -16\n");
                            printf("lw $t1, 0($sp)\n");
                            printf("sle $a0, $t1, $a0\n");
                            printf("sw $a0, 0($sp)\n");
                            printf("add $sp, $sp, 16\n");
                            printf("\n");
                            break;				

			case GTN	:
							printf("addiu $sp, $sp, -16\n");
                            printf("lw $a0, 0($sp)\n");
                            printf("addiu $sp, $sp, -16\n");
                            printf("lw $t1, 0($sp)\n");
                            printf("sgt $a0, $t1, $a0\n");
                            printf("sw $a0, 0($sp)\n");
                            printf("add $sp, $sp, 16\n");
                            printf("\n");
							break;
			case GTNE	:
							printf("addiu $sp, $sp, -16\n");
                            printf("lw $a0, 0($sp)\n");
                            printf("addiu $sp, $sp, -16\n");
                            printf("lw $t1, 0($sp)\n");
                            printf("sge $a0, $t1, $a0\n");
                            printf("sw $a0, 0($sp)\n");
                            printf("add $sp, $sp, 16\n");
                            printf("\n");
							break;								

			case EQ		:
							printf("addiu $sp, $sp, -16\n");
                            printf("lw $a0, 0($sp)\n");
                            printf("addiu $sp, $sp, -16\n");
                            printf("lw $t1, 0($sp)\n");
                            printf("seq $a0, $t1, $a0\n");
                            printf("sw $a0, 0($sp)\n");
                            printf("add $sp, $sp, 16\n");
                            printf("\n");
							break;

			case NEQ		:
							printf("addiu $sp, $sp, -16\n");
                            printf("lw $a0, 0($sp)\n");
                            printf("addiu $sp, $sp, -16\n");
                            printf("lw $t1, 0($sp)\n");
                            printf("sne $a0, $t1, $a0\n");
                            printf("sw $a0, 0($sp)\n");
                            printf("add $sp, $sp, 16\n");
                            printf("\n");
							break;								

            case LABEL  : printf("LABEL%d:\n", code[i].arg);
                            printf("\n");
                            break;


            default:
                            break;
        }

    }
}