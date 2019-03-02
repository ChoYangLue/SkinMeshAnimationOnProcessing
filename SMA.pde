import java.nio.*;

PShader shader;
float a;

float[] positions;
float[] colors;
int[] indices;
int[] boneind;
float[] boneweight;
float[] BOF;
float[] iBOF;

FloatBuffer posBuffer;
FloatBuffer colorBuffer;
IntBuffer indexBuffer;
IntBuffer boneindBuffer;
FloatBuffer boneWeightBuffer;

int posVboId;
int colorVboId;
int indexVboId;
int boneindVboId;
int boneWeightVboId;

int posLoc; 
int colorLoc;
int boneindLoc;
int boneweightLoc;

int boneMLoc0;
int boneMLoc1;

int ibofLoc0;
int ibofLoc1;

int timeLoc;

void setup() {
  size(800, 600, P3D);

  shader = loadShader("frag.glsl", "vert.glsl");  

  //positions = new float[24];
  positions = new float[18];
  //colors = new float[32];
  colors = new float[24];
  indices = new int[12];
  boneind = new int[18];
  boneweight = new float[18];
  BOF = new float[6];
  iBOF = new float[6];

  posBuffer = allocateDirectFloatBuffer(32);
  colorBuffer = allocateDirectFloatBuffer(32); 
  indexBuffer = allocateDirectIntBuffer(12);
  boneindBuffer = allocateDirectIntBuffer(32);
  boneWeightBuffer =  allocateDirectFloatBuffer(32); 

  PGL pgl = beginPGL();  

  // Get GL ids for all the buffers
  IntBuffer intBuffer = IntBuffer.allocate(5);  
  pgl.genBuffers(5, intBuffer);
  posVboId = intBuffer.get(0);
  colorVboId = intBuffer.get(1);
  indexVboId = intBuffer.get(2); 
  boneindVboId = intBuffer.get(3); 
  boneWeightVboId = intBuffer.get(4); 

  // Get the location of the attribute variables.
  shader.bind();
  posLoc = pgl.getAttribLocation(shader.glProgram, "position");
  colorLoc = pgl.getAttribLocation(shader.glProgram, "color");
  
  boneindLoc = pgl.getAttribLocation(shader.glProgram, "boneind");
  
  boneweightLoc = pgl.getAttribLocation(shader.glProgram, "boneweight");
  
  boneMLoc0 = pgl.getUniformLocation(shader.glProgram, "bof[0]");
  boneMLoc1 = pgl.getUniformLocation(shader.glProgram, "bof[1]");
  
  ibofLoc0 = pgl.getUniformLocation(shader.glProgram, "ibof[0]");
  ibofLoc1 = pgl.getUniformLocation(shader.glProgram, "ibof[1]");
  
  print(boneweightLoc);
  
  timeLoc = pgl.getUniformLocation(shader.glProgram, "time");
  shader.unbind();

  endPGL();
  
  createGeometry();
  //updateGeometry();
}

void draw() {
  background(200);
  PGL pgl = beginPGL(); 

  shader.bind();
  
  pgl.enableVertexAttribArray(posLoc);
  pgl.enableVertexAttribArray(colorLoc);  
  pgl.enableVertexAttribArray(boneindLoc); 
  pgl.enableVertexAttribArray(boneweightLoc); 
  
  pgl.uniform1f(timeLoc, a);
  
  //pgl.uniform3f(boneMLoc, boneM[0], boneM[1], boneM[2]);
  pgl.uniform3f(boneMLoc0, BOF[0], BOF[1], BOF[2] );
  pgl.uniform3f(boneMLoc1, BOF[3], BOF[4], BOF[5] );
  
  pgl.uniform3f(ibofLoc0, iBOF[0], iBOF[1], iBOF[2] );
  pgl.uniform3f(ibofLoc1, iBOF[3], iBOF[4], iBOF[5] );

  // Copy vertex data to VBOs
  pgl.bindBuffer(PGL.ARRAY_BUFFER, posVboId);
  pgl.bufferData(PGL.ARRAY_BUFFER, Float.BYTES * positions.length, posBuffer, PGL.DYNAMIC_DRAW);
  pgl.vertexAttribPointer(posLoc, 3, PGL.FLOAT, false, 3 * Float.BYTES, 0);

  pgl.bindBuffer(PGL.ARRAY_BUFFER, colorVboId);  
  pgl.bufferData(PGL.ARRAY_BUFFER, Float.BYTES * colors.length, colorBuffer, PGL.DYNAMIC_DRAW);
  pgl.vertexAttribPointer(colorLoc, 4, PGL.FLOAT, false, 4 * Float.BYTES, 0);
  
  pgl.bindBuffer(PGL.ARRAY_BUFFER, boneindVboId);
  pgl.bufferData(PGL.ARRAY_BUFFER, Integer.BYTES * boneind.length, boneindBuffer, PGL.DYNAMIC_DRAW);
  pgl.vertexAttribPointer(boneindLoc, 3, PGL.INT, false, 3 * Integer.BYTES, 0);
  
  pgl.bindBuffer(PGL.ARRAY_BUFFER, boneWeightVboId);
  pgl.bufferData(PGL.ARRAY_BUFFER, Float.BYTES * boneweight.length, boneWeightBuffer, PGL.DYNAMIC_DRAW);
  pgl.vertexAttribPointer(boneweightLoc, 3, PGL.FLOAT, false, 3 * Float.BYTES, 0);

  pgl.bindBuffer(PGL.ARRAY_BUFFER, 0);

  // Draw the triangle elements
  pgl.bindBuffer(PGL.ELEMENT_ARRAY_BUFFER, indexVboId);
  pgl.bufferData(PGL.ELEMENT_ARRAY_BUFFER, Integer.BYTES * indices.length, indexBuffer, PGL.STATIC_DRAW);
  pgl.drawElements(PGL.TRIANGLES, indices.length, PGL.UNSIGNED_INT, 0);
  pgl.bindBuffer(PGL.ELEMENT_ARRAY_BUFFER, 0);    

  pgl.disableVertexAttribArray(posLoc);
  pgl.disableVertexAttribArray(colorLoc); 
  pgl.disableVertexAttribArray(boneindLoc); 
  pgl.disableVertexAttribArray(boneweightLoc); 
  shader.unbind();

  endPGL();

  a += 0.01;
}

void createGeometry() {
  // Vertex 1
  positions[0] = 50;
  positions[1] = 50;
  positions[2] = 0;

  colors[0] = 1.0f;
  colors[1] = 0.0f;
  colors[2] = 0.0f;
  colors[3] = 1.0f;

  // Vertex 2
  positions[3] = 150;
  positions[4] = 50;
  positions[5] = 0;

  colors[4] = 1.0f;
  colors[5] = 1.0f;
  colors[6] = 0.0f;
  colors[7] = 1.0f;

  // Vertex 3
  positions[6] = 50;
  positions[7] = 150;
  positions[8] = 0;   

  colors[8] = 0.0f;
  colors[9] = 1.0f;
  colors[10] = 0.0f;
  colors[11] = 1.0f;

  // Vertex 4
  positions[9] = 150;
  positions[10] = 150;
  positions[11] = 0;

  colors[12] = 0.0f;
  colors[13] = 1.0f;
  colors[14] = 1.0f;
  colors[15] = 1.0f; 
  
  // Vertex 5
  positions[12] = 50;
  positions[13] = 250;
  positions[14] = 0;

  colors[16] = 0.0f;
  colors[17] = 0.0f;
  colors[18] = 1.0f;
  colors[19] = 1.0f;

  // Vertex 6
  positions[15] = 150;
  positions[16] = 250;
  positions[17] = 0;

  colors[20] = 1.0f;
  colors[21] = 0.0f;
  colors[22] = 1.0f;
  colors[23] = 1.0f;
  
  // Triangle 1
  indices[0] = 0;
  indices[1] = 2;
  indices[2] = 3;

  // Triangle 2
  indices[3] = 0;
  indices[4] = 1;
  indices[5] = 3;

  // Triangle 3
  indices[6] = 2;
  indices[7] = 4;
  indices[8] = 5;

  // Triangle 4
  indices[9] = 2;
  indices[10] = 3;
  indices[11] = 5;  
  
  // bone index
  boneind[0] = 0;
  boneind[1] = 0;
  boneind[2] = 0;
  
  boneind[3] = 0;
  boneind[4] = 0;
  boneind[5] = 0;
  
  boneind[6] = 1;
  boneind[7] = 0;
  boneind[8] = 0;
  
  boneind[9] = 1;
  boneind[10] = 0;
  boneind[11] = 0;
  
  boneind[12] = 1;
  boneind[13] = 1;
  boneind[14] = 1;
  
  boneind[15] = 1;
  boneind[16] = 1;
  boneind[17] = 1;
  
  // bone weight
  boneweight[0] = 1;
  boneweight[1] = 0;
  boneweight[2] = 0;
  
  boneweight[3] = 1;
  boneweight[4] = 0;
  boneweight[5] = 0;
  
  boneweight[6] = 0.5;
  boneweight[7] = 0;
  boneweight[8] = 0;
  
  boneweight[9] = 0.5;
  boneweight[10] = 0;
  boneweight[11] = 0;
  
  boneweight[12] = 1;
  boneweight[13] = 0;
  boneweight[14] = 0;
  
  boneweight[15] = 1;
  boneweight[16] = 0;
  boneweight[17] = 0;
  
  // bof
  BOF[0] = 400;
  BOF[1] = 300;
  BOF[2] = 0;
  
  BOF[3] = 400;
  BOF[4] = 300;
  BOF[5] = 0;
  
  // ibof
  iBOF[0] = -100;
  iBOF[1] = -150;
  iBOF[2] = 0;
  
  iBOF[3] = -100;
  iBOF[4] = -150;
  iBOF[5] = 0;
  
  posBuffer.rewind();
  posBuffer.put(positions);
  posBuffer.rewind();

  colorBuffer.rewind();
  colorBuffer.put(colors);
  colorBuffer.rewind();

  indexBuffer.rewind();
  indexBuffer.put(indices);
  indexBuffer.rewind();
  
  boneindBuffer.rewind();
  boneindBuffer.put(boneind);
  boneindBuffer.rewind();
  
  boneWeightBuffer.rewind();
  boneWeightBuffer.put(boneweight);
  boneWeightBuffer.rewind();
  
}

FloatBuffer allocateDirectFloatBuffer(int n) {
  return ByteBuffer.allocateDirect(n * Float.BYTES).order(ByteOrder.nativeOrder()).asFloatBuffer();
}

IntBuffer allocateDirectIntBuffer(int n) {
  return ByteBuffer.allocateDirect(n * Integer.BYTES).order(ByteOrder.nativeOrder()).asIntBuffer();
}
