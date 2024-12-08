#include <fstream>
#include <iostream>
#include <stdio.h>

using namespace std;

struct TermDescriptor
{
    unsigned int            VarId;
    bool                    Voltage;
    bool                    Left;
    bool                    Const;
    unsigned int            ParamDepCount;
    unsigned int *          ParamDepList;
    float                   Constant;
};

struct EquationDescriptor
{
    unsigned int            TermCount;
    TermDescriptor *        TermList;
};

struct CurrentDescriptor
{
    unsigned int            InstanceId;
    unsigned int            TerminalId;
};

struct TypeDescriptor
{
    unsigned int            TerminalCount;
    unsigned int            ParameterCount;
    unsigned int            EquationCount;
    EquationDescriptor *    EquationStructList;
};

struct InstanceDescriptor
{
    TypeDescriptor *        Type;
    unsigned int *          NodeList;
    float *                 ParameterList;
};

struct NodeDescriptor
{
    unsigned int            ConnectionCount;
    CurrentDescriptor *     ConnectionList;
};

struct NetList
{
    float                   TimeStep;

    unsigned int            TypeCount;
    unsigned int            InstanceCount;
    unsigned int            NodeCount;
    unsigned int            CurrentCount;

    TypeDescriptor *        TypeList;
    NodeDescriptor *        NodeList;
    InstanceDescriptor *    InstanceList;
    CurrentDescriptor *     CurrentList;
};

/*struct OperandDescriptor
{
    unsigned int            Id;
    bool                    Voltage;
    bool                    Left;
    bool                    Const;
};*/

struct CompStruct
{
//    OperandDescriptor *     MapList;

    unsigned int            EquationCount;
    
    unsigned int *          LHSOperandList;
    unsigned int *          RHSOperandList;
    float **                LHSCoeffList;
    float **                RHSCoeffList;

    unsigned int            OptLHSOperandCount;
    unsigned int            OptRHSOperandCount;
    unsigned int *          OptLHSOperandList;
    unsigned int *          OptRHSOperandList;
    float **                OptLHSCoeffList;
    float **                OptRHSCoeffList;

    float **                DiaCoeffList;
};

char Message[256];

int ReadTypeDescriptors(ifstream & fi, NetList & net)
{
    unsigned int type_id;
    char c;

    net.TypeList = new TypeDescriptor[net.TypeCount];
    for(unsigned int i = 0 ; i < net.TypeCount ; i++){
        fi >> c;
        if(c != '#'){
            sprintf(Message, "Netlist Error : Expected '#' at start of line\n");
            return 1;
        }

        fi >> type_id;
        if(type_id >= net.TypeCount){
            sprintf(Message, "Netlist error : Type ID [0x%X] is out of range\n", type_id);
            return 1;
        }

        fi  >> net.TypeList[type_id].TerminalCount >> net.TypeList[type_id].ParameterCount
            >> net.TypeList[type_id].EquationCount;
    }
    printf("\n");

for(unsigned int i = 0 ; i < net.TypeCount ; i++){
    printf("# %d %d %d %d\n", i, net.TypeList[i].TerminalCount,
               net.TypeList[i].ParameterCount, net.TypeList[i].EquationCount);
}

    return 0;
}

int ReadInstanceDescriptors(ifstream & fi, NetList & net)
{
    unsigned int instance_id, type_id;
    char c;

    net.CurrentCount = 0;
    net.InstanceList = new InstanceDescriptor[net.InstanceCount];
    for(unsigned int i = 0 ; i < net.InstanceCount ; i++){
        fi >> c;
        if(c != '!'){
            sprintf(Message, "Netlist error : Expected '!' at start of line\n");
            return 1;
        }

        fi >> instance_id;
        if(instance_id >= net.InstanceCount){
            sprintf(Message, "Netlist error : Instance ID [0x%X] is out of range\n", instance_id);
            return 1;
        }

        fi >> type_id;

        printf("\n! %d %d\t", instance_id, type_id);

        if(type_id >= net.TypeCount){
            sprintf(Message, "Netlist error : Type ID [0x%X] of Instance [0x%X] is out of range\n",
                    type_id, instance_id);
        }
        net.InstanceList[instance_id].Type = &net.TypeList[type_id];

        net.InstanceList[instance_id].NodeList =
                                    new unsigned int[net.InstanceList[instance_id].Type->TerminalCount];
        for(unsigned int j = 0 ; j < net.InstanceList[instance_id].Type->TerminalCount ; j++){
            fi >> net.InstanceList[instance_id].NodeList[j];
            net.CurrentCount++;
            printf("%d ", net.InstanceList[instance_id].NodeList[j]);
        }

        printf("\t");
        net.InstanceList[instance_id].ParameterList =
                                    new float[net.InstanceList[instance_id].Type->ParameterCount];
        for(unsigned int j = 0 ; j < net.InstanceList[instance_id].Type->ParameterCount ; j++){
            fi >> net.InstanceList[instance_id].ParameterList[j];
            printf("%g ", net.InstanceList[instance_id].ParameterList[j]);
        }
    }
    printf("\n");

for(unsigned int i = 0 ; i < net.InstanceCount ; i++){
    printf("! %d - %d |", i, net.InstanceList[i].Type->TerminalCount);
    for(unsigned int j = 0 ; j < net.InstanceList[i].Type->TerminalCount ; j++){
        printf("%d ", net.InstanceList[i].NodeList[j]);
    }
    printf("\n");
}
    return 0;
}

int ReadNodeDescriptors(ifstream & fi, NetList & net)
{
    unsigned int node_id;
    char c;

    net.NodeList = new NodeDescriptor[net.NodeCount];
    for(unsigned int i = 0 ; i < net.NodeCount ; i++)
    {
        fi >> c;
        if(c != '@'){
            sprintf(Message, "Netlist Error : Expected '@' at start of line\n");
            return 1;
        }

        fi >> node_id;
        if(node_id <= 0 || node_id > net.NodeCount){
            sprintf(Message, "Netlist error : Node ID [0x%X] is out of range\n", node_id);
            return 1;
        }

        fi >> net.NodeList[node_id-1].ConnectionCount;

        printf("\n@ %d %d\t", node_id, net.NodeList[node_id-1].ConnectionCount);
        net.NodeList[node_id-1].ConnectionList =
                                new CurrentDescriptor[net.NodeList[node_id-1].ConnectionCount];
        for(unsigned int j = 0 ; j < net.NodeList[i].ConnectionCount ; j++)
        {
            fi >> net.NodeList[node_id-1].ConnectionList[j].InstanceId;
            if(net.NodeList[node_id-1].ConnectionList[j].InstanceId >= net.InstanceCount){
                sprintf(Message,
                        "Netlist Error : Instance ID [0x%X] connected to node [0x%X] is out of range\n",
                        net.NodeList[node_id-1].ConnectionList[j].InstanceId, node_id);
                return 1;
            }

            fi >> c;
            if(c != '.'){
                sprintf(Message, "Netlist Error : Expected '.' between Instance ID and Terminal ID\n");
                return 1;
            }

            fi >> net.NodeList[node_id-1].ConnectionList[j].TerminalId;
            if(net.NodeList[node_id-1].ConnectionList[j].TerminalId >=
               net.InstanceList[net.NodeList[node_id-1].ConnectionList[j].InstanceId].Type->TerminalCount)
            {
                sprintf(Message,
                       "Netlist Error : Terminal ID [0x%X] of Instance [0x%X] connected to node "\
                       "[0x%X] is out of range\n", net.NodeList[node_id-1].ConnectionList[j].TerminalId,
                       net.NodeList[node_id-1].ConnectionList[j].InstanceId, node_id);
                return 1;
            }

            printf("%d.%d ", net.NodeList[node_id-1].ConnectionList[j].InstanceId,
                             net.NodeList[node_id-1].ConnectionList[j].TerminalId);
        }
    }
    printf("\n");

    return 0;
}

int ReadTerms(ifstream & fi, EquationDescriptor & ed)
{
    char c;

    TermDescriptor * tlist = new TermDescriptor[1];
    tlist[0].Constant = 1;
    tlist[0].Const = true;
    tlist[0].ParamDepCount = 0;
    tlist[0].ParamDepList = NULL;

    unsigned int tindex = 0;

    bool foundequal = false;
    bool sos = true;
    bool minus = false;

    while(!fi.eof()){
        fi >> c;

        if(c == 'v'){
            tlist[tindex].Voltage = true;
            tlist[tindex].Left = true;
            tlist[tindex].Const = false;
            fi >> tlist[tindex].VarId;
            sos = false;
        }else if(c == 'i'){
            tlist[tindex].Voltage = false;
            tlist[tindex].Left = true;
            tlist[tindex].Const = false;
            fi >> tlist[tindex].VarId;
            sos = false;
        }else if(c == 'u'){
            tlist[tindex].Voltage = true;
            tlist[tindex].Left = false;
            tlist[tindex].Const = false;
            fi >> tlist[tindex].VarId;
            sos = false;
        }else if(c == 'h'){
            tlist[tindex].Voltage = false;
            tlist[tindex].Left = false;
            tlist[tindex].Const = false;
            fi >> tlist[tindex].VarId;
            sos = false;
        }else if(c == '$'){
            unsigned int * temp_plist = new unsigned int[tlist[tindex].ParamDepCount + 1];
            for(unsigned int i = 0 ; i < tlist[tindex].ParamDepCount ; i++){
                temp_plist[i] = tlist[tindex].ParamDepList[i];
            }
            fi >> temp_plist[tlist[tindex].ParamDepCount];

            if(tlist[tindex].ParamDepList){
                delete[] tlist[tindex].ParamDepList;
            }
            tlist[tindex].ParamDepList = temp_plist;
            tlist[tindex].ParamDepCount++;
            sos = false;
        }else if(c == '^'){
            float g;

            fi >> g;
            tlist[tindex].Constant *= g;
            sos = false;
        }else if(c == '+'){
            if(!sos){
                tlist[tindex].Constant *= minus ? -1 : 1;
                tlist[tindex].Constant *= foundequal ? -1 : 1;
                TermDescriptor * temp_tlist = new TermDescriptor[tindex + 2];
                for(unsigned int i = 0 ; i <= tindex ; i++){
                    temp_tlist[i] = tlist[i];
                }
                delete[] tlist;
                tlist = temp_tlist;

                tindex++;
                tlist[tindex].Constant = 1;
                tlist[tindex].Const = true;
                tlist[tindex].ParamDepCount = 0;
                tlist[tindex].ParamDepList = NULL;
            }
            minus = false;
        }else if(c == '-'){
            if(!sos){
                tlist[tindex].Constant *= minus ? -1 : 1;
                tlist[tindex].Constant *= foundequal ? -1 : 1;
                TermDescriptor * temp_tlist = new TermDescriptor[tindex + 2];
                for(unsigned int i = 0 ; i <= tindex ; i++){
                    temp_tlist[i] = tlist[i];
                }
                delete[] tlist;
                tlist = temp_tlist;

                tindex++;
                tlist[tindex].Constant = 1;
                tlist[tindex].Const = true;
                tlist[tindex].ParamDepCount = 0;
                tlist[tindex].ParamDepList = NULL;
            }
            minus = true;
        }else if(c == '='){
            tlist[tindex].Constant *= minus ? -1 : 1;
            tlist[tindex].Constant *= foundequal ? -1 : 1;
            TermDescriptor * temp_tlist = new TermDescriptor[tindex + 2];
            for(unsigned int i = 0 ; i <= tindex ; i++){
                temp_tlist[i] = tlist[i];
            }
            delete[] tlist;
            tlist = temp_tlist;

            tindex++;
            tlist[tindex].Constant = 1;
            tlist[tindex].Const = true;
            tlist[tindex].ParamDepCount = 0;
            tlist[tindex].ParamDepList = NULL;

            foundequal = true;
            sos = true;
            minus = false;
        }else if(c == '*'){
            // Do nothing
        }else if(c == ';'){
            tlist[tindex].Constant *= minus ? -1 : 1;
            tlist[tindex].Constant *= foundequal ? -1 : 1;
            break;
        }else{
            sprintf(Message, "Netlist error : Unexpected character %c\n", c);
            return 1;
        }
    }

    ed.TermCount = tindex + 1;
    ed.TermList = tlist;

    return 0;
}

void DispEqn(EquationDescriptor & ed)
{
    for(unsigned int i = 0 ; i < ed.TermCount ; i++){
        printf("+ ");
        printf("%g ", ed.TermList[i].Constant);
        if(ed.TermList[i].ParamDepCount > 0){
            for(unsigned int j = 0 ; j < ed.TermList[i].ParamDepCount ; j++){
                printf("* $%d ", ed.TermList[i].ParamDepList[j]);
            }
        }

        if(!ed.TermList[i].Const){
            if(ed.TermList[i].Voltage){
                printf(ed.TermList[i].Left ? "* v%d " : "* u%d ", ed.TermList[i].VarId);
            }else{
                printf(ed.TermList[i].Left ? "* i%d " : "* h%d ", ed.TermList[i].VarId);
            }
        }
    }
    printf("= 0;\n");
}

int ReadEquationDescriptors(ifstream & fi, NetList & net)
{
    for(unsigned int i = 0 ; i < net.TypeCount ; i++){
        char c;
        unsigned int type_id;

        fi >> c;
        if(c != '{'){
            sprintf(Message, "Netlist error : Expected '{' at start of line\n");
            return 1;
        }

        fi >> type_id;
        if(type_id >= net.TypeCount){
            sprintf(Message, "Netlist error : Type ID [0x%X] is out of range", type_id);
            return 1;
        }

        printf("TID : %d\n", type_id);
        net.TypeList[type_id].EquationStructList = 
                                            new EquationDescriptor[net.TypeList[type_id].EquationCount];
        for(unsigned int j = 0 ; j < net.TypeList[type_id].EquationCount ; j++){
            if(ReadTerms(fi, net.TypeList[type_id].EquationStructList[j])){
                return 1;
            }
            printf("j : %d -> ", j);
            DispEqn(net.TypeList[type_id].EquationStructList[j]);
        }

        fi >> c;
        if(c != '}'){
            sprintf(Message, "Netlist error : Expected '}' at start of line\n");
            return 1;
        }
    }

    return 0;
}

int FetchDescriptors(ifstream & fi, NetList & net)
{
    char c;
    int ret;

    fi.seekg(0);

    fi >> c;
    if(c != 'T'){
        sprintf(Message, "Netlist Error : Expected 'T' at start of line\n");
        return 1;
    }
    fi >> net.TimeStep;
    printf("Timestep : %g\n", net.TimeStep);

    fi >> c;
    if(c != '~'){
        sprintf(Message, "Netlist Error : Expected '~' at start of line\n");
        return 1;
    }
    fi >> net.TypeCount;
    printf("Type Count : %d\n", net.TypeCount);

    fi >> c;
    if(c != '|'){
        sprintf(Message, "Netlist Error : Expected '~' at start of line\n");
        return 1;
    }
    fi >> net.InstanceCount;
    printf("instance Count : %d\n", net.InstanceCount);

    fi >> c;
    if(c != '%'){
        sprintf(Message, "Netlist Error : Expected '~' at start of line\n");
        return 1;
    }
    fi >> net.NodeCount;
    printf("Node Count : %d\n", net.NodeCount);

    ret = ReadTypeDescriptors(fi, net);
    if(ret){
        return ret;
    }

    ret = ReadInstanceDescriptors(fi, net);
    if(ret){
        return ret;
    }

    ret = ReadNodeDescriptors(fi, net);
    if(ret){
        return ret;
    }

    printf("\nCurrent Count : %d\n", net.CurrentCount);

    ret = ReadEquationDescriptors(fi, net);
    if(ret){
        return ret;
    }

    fi >> c;
    if(c != ':'){
        sprintf(Message, "Netlist error : Expected ':' at the end of file\n");
        return 1;
    }

    return 0;
}

int MapIds(NetList & net, CompStruct & cs)
{
    net.CurrentList = new CurrentDescriptor[net.CurrentCount];
    unsigned int cindex = 0;

    for(unsigned int i = 0 ; i < net.InstanceCount ; i++){
        for(unsigned int j = 0 ; j < net.InstanceList[i].Type->TerminalCount ; j++){
            net.CurrentList[cindex].InstanceId = i;
            net.CurrentList[cindex].TerminalId = j;
            cindex++;
        }
    }

for(unsigned int i = 0 ; i < net.CurrentCount ; i++){
    printf("%d : %d.%d\n", i, net.CurrentList[i].InstanceId, net.CurrentList[i].TerminalId);
}

    if(cindex != net.CurrentCount){
        sprintf(Message, "Fatal error : No. of currents does not match the no. of terminals\n");
        return 1;
    }

/*
    cs.MapList = new OperandDescriptor[2*(net.NodeCount + net.CurrentCount)+1];
    unsigned int idindex = 0;
    for(unsigned int i = 0 ; i < net.NodeCount ; i++){
        cs.MapList[idindex].Id = i;
        cs.MapList[idindex].Voltage = true;
        cs.MapList[idindex].Left = true;
        cs.MapList[idindex].Const = false;
        idindex++;
    }

    for(unsigned int i = 0 ; i < net.CurrentCount ; i++){
        cs.MapList[idindex].Id = i;
        cs.MapList[idindex].Voltage = false;
        cs.MapList[idindex].Left = true;
        cs.MapList[idindex].Const = false;
        idindex++;
    }

    for(unsigned int i = 0 ; i < net.NodeCount ; i++){
        cs.MapList[idindex].Id = i;
        cs.MapList[idindex].Voltage = true;
        cs.MapList[idindex].Left = false;
        cs.MapList[idindex].Const = false;
        idindex++;
    }

    for(unsigned int i = 0 ; i < net.CurrentCount ; i++){
        cs.MapList[idindex].Id = i;
        cs.MapList[idindex].Voltage = true;
        cs.MapList[idindex].Left = false;
        cs.MapList[idindex].Const = false;
        idindex++;
    }

    cs.MapList[idindex].Const = true;  // The last operand is the constant
*/
    return 0;
}

int FormEquations(NetList & net, CompStruct & cs)
{
    int retval;

    cs.EquationCount = net.NodeCount + net.InstanceCount;
    for(unsigned int i = 0 ; i < net.InstanceCount ; i++){
        cs.EquationCount += net.InstanceList[i].Type->EquationCount;
    }

    if(cs.EquationCount > net.NodeCount + net.CurrentCount){
        sprintf(Message, "Warning : Redundant equations found in component script."\
                         " This may cause faulty simulation\n");
        retval = 2;
    }else if(cs.EquationCount < net.NodeCount + net.CurrentCount){
        sprintf(Message,"Warning : Too few equations were found. Optimization or later steps can fail.\n");
        retval = 2;
    }else{
        retval = 0;
    }

printf("EC : %d\n", cs.EquationCount);

    cs.LHSCoeffList = new float*[cs.EquationCount];
    for(unsigned int i = 0 ; i < cs.EquationCount ; i++){
        cs.LHSCoeffList[i] = new float[net.NodeCount + net.CurrentCount];
        for(unsigned int j = 0 ; j < net.NodeCount + net.CurrentCount ; j++){
            cs.LHSCoeffList[i][j] = 0;
        }
    }

    cs.RHSCoeffList = new float*[cs.EquationCount];
    for(unsigned int i = 0 ; i < cs.EquationCount ; i++){
        cs.RHSCoeffList[i] = new float[net.NodeCount + net.CurrentCount + 1];
        for(unsigned int j = 0 ; j < net.NodeCount + net.CurrentCount+1 ; j++){
            cs.RHSCoeffList[i][j] = 0;
        }
    }

    cs.LHSOperandList = new unsigned int[net.NodeCount + net.CurrentCount];
    cs.RHSOperandList = new unsigned int[net.NodeCount + net.CurrentCount + 1];
    for(unsigned int i = 0 ; i < 2*(net.NodeCount + net.CurrentCount)+1 ; i++){
        if(i < net.NodeCount + net.CurrentCount){
            cs.LHSOperandList[i] = i;
        }else{
            cs.RHSOperandList[i] = i - (net.NodeCount + net.CurrentCount);
        }
    }


for(unsigned int i = 0 ; i < 2*(net.NodeCount + net.CurrentCount)+1 ; i++){
        if(i < net.NodeCount + net.CurrentCount){
            printf("%d ", cs.LHSOperandList[i]);
        }else{
            printf("%d ", cs.RHSOperandList[i]);
        }
}

printf("\n\n");

    unsigned int eqnindex = 0;
    for(eqnindex = 0 ; eqnindex < net.NodeCount ; eqnindex++){
        for(unsigned int j = 0 ; j < net.NodeList[eqnindex].ConnectionCount ; j++){
printf("%d.%d | ", net.NodeList[eqnindex].ConnectionList[j].InstanceId,
                  net.NodeList[eqnindex].ConnectionList[j].TerminalId);
            unsigned int k;
            for(k = 0 ; k < net.CurrentCount ; k++){
                if(net.CurrentList[k].InstanceId == net.NodeList[eqnindex].ConnectionList[j].InstanceId && 
                   net.CurrentList[k].TerminalId == net.NodeList[eqnindex].ConnectionList[j].TerminalId){
                    break;
                }
            }
            if(k >= net.CurrentCount){
                sprintf(Message, "Fatal error : 1\n");
                return 1;
            }
            
            cs.LHSCoeffList[eqnindex][net.NodeCount + k] = 1;
        }
        cs.RHSCoeffList[eqnindex][net.NodeCount + net.CurrentCount] = 0;
printf("\n");
    }

printf("\n\n");
    
for(unsigned int i = 0 ; i < net.NodeCount ; i++){
    for(unsigned int j = 0 ; j < net.NodeCount + net.CurrentCount ; j++){
        printf("%5g", cs.LHSCoeffList[i][j]);
    }
    
    printf("  = %5g\n", cs.RHSCoeffList[i][net.NodeCount + net.CurrentCount]);
}
    
printf("\n\n");
    
    // Now eqnindex == net.NodeCount
    for( ; eqnindex < net.NodeCount + net.InstanceCount ; eqnindex++){
        for(unsigned int j = 0 ; j < net.InstanceList[eqnindex - net.NodeCount].Type->TerminalCount ; j++){
printf("%d.%d | ", eqnindex-net.NodeCount, j);
            unsigned int k;
            for(k = 0 ; k < net.CurrentCount ; k++){
                if(net.CurrentList[k].InstanceId == eqnindex - net.NodeCount &&
                   net.CurrentList[k].TerminalId == j){
                    break;
                }
            }
            if(k >= net.CurrentCount){
                sprintf(Message, "Fatal error : 2\n");
                return 1;
            }
            
            cs.LHSCoeffList[eqnindex][net.NodeCount + k] = 1;
        }
        cs.RHSCoeffList[eqnindex][net.NodeCount + net.CurrentCount] = 0;
printf("\n");
    }

for(unsigned int i = 0 ; i < net.NodeCount + net.InstanceCount ; i++){
    for(unsigned int j = 0 ; j < net.NodeCount + net.CurrentCount ; j++){
        printf("%5g", cs.LHSCoeffList[i][j]);
    }
    printf("  = %5g\n", cs.RHSCoeffList[i][net.NodeCount + net.CurrentCount]);
}

    // Now eqnindex == net.NodeCount + net.InstanceCount
    for( ; eqnindex < cs.EquationCount ; eqnindex++){
        
    }

    return retval;
}

int main(int argc, char * argv[])
{
    if(argc != 2)
    {
        printf("Error : Wrong number of arguments\n\n");
        printf("Usage : netread <input file>\n");

        return 1;
    }

    NetList netlist;
    CompStruct compstruct;
    ifstream fin(argv[1]);
    int ret;

    printf("%-50s", "Reading circuit netlist : ");
    ret = FetchDescriptors(fin, netlist);
    if(ret){
        printf("[ FAILURE ]\n");
        printf(Message);
        fin.close();
        return 1;
    }else{
        printf("[ SUCCESS ]\n");
    }

    printf("%-50s", "Mapping variable IDs : ");
    ret = MapIds(netlist, compstruct);
    if(ret){
        printf("[ FAILURE ]\n");
        printf(Message);
        fin.close();
        return 1;
    }else{
        printf("[ SUCCESS ]\n");
    }

    printf("%-50s", "Forming equations : ");
    ret = FormEquations(netlist, compstruct);
    if(ret == 2){
        printf("[ SUCCESS ]\n");
        printf(Message);
    }else if(ret == 1){
        printf("[ FAILURE ]\n");
        printf(Message);
        fin.close();
        return 1;
    }else{
        printf("[ SUCCESS ]\n");
    }

    fin.close();

    return 0;
}

