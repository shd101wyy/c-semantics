module CPP-ABSTRACT-SORTS
     syntax Decl
endmodule

module CPP-ABSTRACT-SYNTAX
     imports CPP-ABSTRACT-SORTS
     imports BOOL
     imports FLOAT-SYNTAX
     imports LIST
     imports STRING-SYNTAX
     imports CPP-DYNAMIC-SORTS
     imports CPP-SORTS
     imports CPP-TYPING-SORTS
     imports COMMON-SORTS
     imports COMPAT-SORTS
     imports CPP-DEPENDENT-SYNTAX
     imports CPP-CLASS-SYNTAX

     syntax CPPIntegerType

     syntax LVal ::= LExpr
     syntax XVal ::= XExpr
     syntax PRVal ::= PRExpr
     syntax GLVal ::= GLExpr
     syntax RVal ::= RExpr
     syntax Val ::= TExpr

     syntax LDep ::= ld(Expr, Trace, CPPTypeExpr, TemplateParam)
     syntax XDep ::= xd(Expr, Trace, CPPTypeExpr, TemplateParam)
     syntax PRDep ::= prd(Expr, Trace, CPPTypeExpr, TemplateParam)
     syntax GLDep ::= LDep | XDep
     syntax RDep ::= XDep | PRDep
     syntax Dep ::= GLDep | RDep

     syntax LVal ::= LDep
     syntax XVal ::= XDep
     syntax PRVal ::= PRDep
     syntax GLVal ::= GLDep
     syntax RVal ::= RDep 
     syntax Val ::= Dep

     syntax Bool ::= isDepKLabel(K) [function, klabelPredicate]

     syntax TemplateParam ::= param(Dep) [function]

     syntax SymBase ::= "nonStatic" 

     syntax TypeId ::= TypeId(AType)
                     | DestructorTypeId(AType)
     syntax CId ::= TypeId

     syntax Decl ::= TranslationUnit(String, List)
                   | TypedefDecl(CId, AType) [strict(2)]
                   | TypeAliasDecl(CId, AType) [strict(2)]
                   | LinkageSpec(String, Bool, List)
                   | NamespaceDecl(CId, Bool, List)
                   | NamespaceAliasDecl(CId, CId, NNS)
                   | Specifier(Specifier, Decl)
                   | Declarator
                   | DeclLoc(CabsLoc, Decl)
                   | FriendDecl(Decl)

     context TypedefDecl(_, HOLE:CPPTypeExpr)
             requires notBool isDependentInScope(HOLE) [result(CPPType)]

     context TypeAliasDecl(_, HOLE:CPPTypeExpr)
             requires notBool isDependentInScope(HOLE) [result(CPPType)]

     syntax CtorInit ::= ConstructorBase(AType, Bool, Bool, Init)
                      | ConstructorMember(CId, Init)

     syntax Declarator ::= FunctionDefinition(NNS, CId, AType, List, AStmt)
                         | FunctionDecl(NNS, CId, AType, List)
                         | VarDecl(NNS, CId, AType, Init, isDirect: Bool)
                         | FieldDecl(NNS, CId, AType, Init)
                         | BitFieldDecl(NNS, CId, AType, Expr) [strict(3)]

     syntax Init ::= NoInit()

     syntax StorageClassSpecifier ::= Register() | Static() | ThreadLocal() | Extern() | Mutable()
     syntax FunctionSpecifier ::= Inline() | Explicit()
     syntax Specifier ::= StorageClassSpecifier | FunctionSpecifier
                        | Constexpr() | Auto()

     syntax Decl ::= Template(Decl, List)
                   | TemplateWithInstantiations(Decl, List, List)
     syntax TemplateParameter ::= TypeTemplateParam(Bool, Bool, AType, AType)
                                | ValueTemplateParam(Bool, NNS, CId, AType, AExpr)
                                | TemplateTemplateParam(Bool, CId, AType, List)

     syntax TemplateArgument ::= TypeArg(AType) [strict]
                               | TemplateArg(CId)
                               | ExprArg(Expr)
                               | PackArg(List)


     context TypeArg(HOLE:CPPTypeExpr)
             requires notBool isDependentInScope(HOLE) [result(CPPType)]

     syntax Decl ::= TemplateSpecialization(AType, Decl)
                   | TemplateInstantiationDeclaration(AType, Decl)
                   | TemplateInstantiationDefinition(AType, Decl)
                   | PartialSpecialization(List, List, Decl)

     syntax Decl ::= ClassDef(Tag, CId, NNS, List, List, Bool)
                   | TypeDecl(AType)
                   | EnumDef(id: CId, nns: NNS, scoped: Bool, fixed: Bool, ut: AType, List) [strict(5)]
                   | OpaqueEnumDeclaration(id: CId, scoped: Bool, ut: AType) [strict(3)]
                   | AccessSpec(AccessSpecifier)
                   | StaticAssert(Expr, Expr)
                   | UsingDecl(Bool, NNS, CId)
                   | UsingDirective(CId, NNS)

     syntax Decl ::= DeclLoc(CabsLoc, Decl)
                   | NoDecl()

     syntax BaseSpecifier ::= BaseClass(Bool, Bool, AccessSpecifier, AType)
     syntax Enumerator ::= Enumerator(CId, AExpr)

     syntax CPPType // defined in CPP-TYPING-SYNTAX

     syntax ATypeResult ::= NoType()
     syntax KResult ::= ATypeResult

     syntax AType ::= CPPTypeExpr
                    | ATypeResult
                    | ElaboratedTypeSpecifier(Tag, CId, NNS)
                    | ElaboratedTypeSpecifier(Tag, CId, NNS, List)
                    | FunctionPrototype(AType, StrictList, ExceptionSpec, Bool) [strict(1)]
                    | MethodPrototype(Bool, Bool, AType, AType) [strict(3, 4)]
                    | StaticMethodPrototype(AType) [strict]
                    | Virtual(AType) [strict]
                    | Pure(AType) [strict]
                    | Explicit(AType) [strict]
                    | BuiltinType(TypeSpecifier)
                    | PointerType(AType) [strict]
                    | MemberPointerType(AType, AType) [strict]
                    | ArrayType(AType, Int) [strict(1)]
                    | ArrayType(AType, AExpr) [strict(1)]
                    | TypedefType(CId)
                    | QualifiedTypeName(Tag, NNS, AType)
                    | Decltype(Expr)
                    | TemplateParameterType(CId)
                    | LValRefType(AType) [strict]
                    | RValRefType(AType) [strict]
                    | TemplateSpecializationType(CId)
                    | TemplateSpecializationType(CId, List)
                    | PackExpansionType(AType)
                    | AutoType(Bool)
                    | Name

     context FunctionPrototype(HOLE:CPPTypeExpr, _, _, _)
             requires notBool isDependentInScope(HOLE) [result(CPPType)]
     context FunctionPrototype(_, HOLE:StrictList => typeStrict(HOLE), _, _)
     context PointerType(HOLE:CPPTypeExpr)
             requires notBool isDependentInScope(HOLE) [result(CPPType)]
     context MemberPointerType(HOLE:CPPTypeExpr, _)
             requires notBool isDependentInScope(HOLE) [result(CPPType)]
     context MemberPointerType(_, HOLE:CPPTypeExpr)
             requires notBool isDependentInScope(HOLE) [result(CPPType)]
     context ArrayType(HOLE:CPPTypeExpr, _::Int)
             requires notBool isDependentInScope(HOLE) [result(CPPType)]
     context ArrayType(HOLE:CPPTypeExpr, _::AExpr)
             requires notBool isDependentInScope(HOLE) [result(CPPType)]
     context LValRefType(HOLE:CPPTypeExpr)
             requires notBool isDependentInScope(HOLE) [result(CPPType)]
     context RValRefType(HOLE:CPPTypeExpr)
             requires notBool isDependentInScope(HOLE) [result(CPPType)]

     // extensions
     syntax AType ::= GnuTypeOfExpr(AType)
                    | GnuEnumUnderlyingType(AType)               

     syntax ExceptionSpec ::= NoExceptionSpec() 
                            | NoexceptSpec(AExpr)
                            | ThrowSpec(StrictList) [strict]

     syntax TypeSpecifier ::= Void() | Char() | WChar() | Char16() | Char32()
                            | Bool() | UChar() | UShort() | UInt() | ULong() 
                            | ULongLong() | SChar() | Short() | Int() | Long()
                            | LongLong() | Float() | Double() | LongDouble()
     
     syntax AType ::= RefQualifier(RefQualifier, AType) [strict(2)]

     syntax AType ::= Qualifier(Qualifier, AType) [strict(2)]
     context Qualifier(_, HOLE:CPPTypeExpr)
             requires notBool isDependentInScope(HOLE) [result(CPPType)]

     syntax AStmt ::= Stmt
     syntax Stmt ::= DeclStmt(List)
                  // GotoStmt(CId)
                   | ReturnStmt(Init)
                   | NullStmt()
                   | ForStmt(Stmt, Expr, Stmt, Stmt)
                   | ForStmt(Stmt, Decl, Stmt, Stmt)
                   | TemplateDefinitionStmt(K) // synthetic statement created by the body of a function template definition when it's evaluted before instantiation
      
     syntax AStmt ::= NoStatement()
                    | CompoundAStmt(List)
                    | LabelAStmt(CId, List)
                    | ForAStmt(AStmt, AExpr, AExpr, AStmt)
                    | ForAStmt(AStmt, Decl, AExpr, AStmt)
                    | WhileAStmt(Decl, AStmt)
                    | WhileAStmt(Expr, AStmt)
                    | DoWhileAStmt(AStmt, Expr)
                    | IfAStmt(Decl, AStmt, AStmt)
                    | IfAStmt(Expr, AStmt, AStmt)
                    | SwitchAStmt(Decl, AStmt)
                    | SwitchAStmt(Expr, AStmt)
                    | CaseAStmt(Expr, AStmt)
                    | DefaultAStmt(AStmt)
                    | TryAStmt(AStmt, List)
                    | CatchAStmt(CatchDecl, AStmt)
                    | CatchStmt(Decl, Stmt)
                    | Expr //expression statement, handled later

     syntax Stmt ::= Defaulted()
                    | Deleted()
                    | Constructor(List, Stmt)
                    | Destructor()

     syntax CatchDecl ::= Decl | Ellipsis()             

     syntax AExpr ::= Expr
                    | NoExpression()

     syntax Expr ::= MemberExpr(Bool, Bool, Name, Expr)
                   | AnonymousUnionObject(AType)
                   | Subscript(Expr, Expr)
                   | Name
                   | UnaryOperator(OpId, Expr)
                   | BinaryOperator(OpId, Expr, Init)
                   | ConditionalOperator(Expr, Expr, Expr)
                   | ParenthesizedCast(AType, Expr) [strict]
                   | StaticCast(AType, Expr) [strict]
                   | DynamicCast(AType, Expr)
                   | FunctionalCast(AType, List) [strict(1)]
                   | SizeofType(AType) [strict]
                   | SizeofExpr(Expr)
                   | AlignofType(AType)
                   | AlignofExpr(Expr)
                   | SizeofPack(CId)
                   | PseudoDestructor(Expr, Bool, NNS, AType, AType)
                   | Noexcept(Expr)
                   | NewExpr(Bool, AType, AExpr, Init, List) [strict(2)]
                   | DeleteExpr(Bool, Bool, Expr)

     syntax ResolvedExpr ::= CallExpr(Expr, StrictList, StrictListResult)

     syntax Expr ::= Lambda(CaptureDefault, List, AType, AStmt)
                   | PackExpansionExpr(Expr)
                   | StringLiteral(CharKind, String)
                   | CharacterLiteral(CharKind, Int)
                   | IntegerLiteral(Int, AType) [strict(2)]
                   | FloatingLiteral(Float, AType) [strict(2)]
                   | NullPointerLiteral()
                   | BoolLiteral(Bool)
                   | Throw(AExpr)

     context IntegerLiteral(_, HOLE:CPPTypeExpr)
             requires notBool isDependentInScope(HOLE) [result(CPPType)]
     context FloatingLiteral(_, HOLE:CPPTypeExpr)
             requires notBool isDependentInScope(HOLE) [result(CPPType)]

     syntax CaptureDefault ::= NoCaptureDefault() | CopyCapture() | RefCapture()
     syntax Capture ::= LambdaCapture(CaptureKind, Bool)
     syntax CaptureKind ::= Decl | This | RefCapture(Decl) [klabel(RefCapture1)]

     syntax CharKind ::= Ascii() | Wide() | UTF8() | UTF16() | UTF32()

     syntax BraceInit ::= BraceInit(List)
     syntax Init ::= BraceInit
     syntax ExpressionList ::= ExpressionList(List)
     syntax Init ::= ExpressionList

     // extensions
     syntax Expr ::= GnuTypeTrait(String, List)
                   | GnuAtomicExpr(String, List)

     // things that are not technically expressions, but will be transformed out
     // of existence by the semantics
     syntax Expr ::= MaterializeTemporaryExpr(Expr)
                   | ConstructorCall(Bool, AType, List)
                   | UnresolvedConstructorCall(AType, List)
                   | TemporaryObjectExpr(AType, List)
                   | ParenList(List)
                   | DefaultArg()

     syntax AStmt ::= StmtLoc(CabsLoc, AStmt)

endmodule

module CPP-ABSTRACT-REWRITING
     imports CPP-SYNTAX
     imports CPP-ABSTRACT-SYNTAX
     imports CPP-DECL-DECLARATOR-SYNTAX
     imports CPP-DYNAMIC-SYNTAX

     rule MemberExpr(false, false, N::Name, E::Expr) 
       => #if hasAnonymousUnionObject(E)
          #then N
          #else #if hasAnonymousUnionObject(N)
                #then E
                #else E . no-template N
                #fi
          #fi [anywhere]
     rule MemberExpr(true, false, N::Name, E::Expr) => BinaryOperator(operator->, E, N) [anywhere]

     syntax Bool ::= hasAnonymousUnionObject(Expr) [function]
     rule hasAnonymousUnionObject(ExprLoc(_, E::Expr) => E)
     rule hasAnonymousUnionObject(Name(NoNNS(), #NoName)) => true
     rule hasAnonymousUnionObject(_) => false [owise]

     rule Subscript(E1::Expr, E2::Expr) => BinaryOperator(operator[], E1, E2) [anywhere]

     rule MaterializeTemporaryExpr(E::Expr) => E [anywhere]
     // technically speaking this case could still be value initialization, but in that
     // case value initialization and default initialization have the same semantics.
     // ideally we would get the distinction between the two correct, but clang doesn't fully
     // distinguish by the time we reach the point of abstract syntax, so this will have to do.
     rule ConstructorCall(false, _, .List) => NoInit() [anywhere]
     rule ConstructorCall(true, _, .List) => ExpressionList(.List) [anywhere]
     rule ConstructorCall(_, _, ListItem(E::Expr)) => E [anywhere]
     rule ConstructorCall(_, _, L::List) => ExpressionList(L)
          requires size(L) >Int 1 [anywhere]
     rule TemporaryObjectExpr(T::AType, L::List) => FunctionalCast(T, L) [anywhere]
     rule TypeId(Name(NoNNS(), X::CId)) => ConstructorId(X) [anywhere]
     rule DestructorTypeId(Name(NoNNS(), X::CId)) => DestructorId(X) [anywhere]
     rule ExprLoc(_, DefaultArg()) => .K [anywhere]

     rule ld(E::Expr, _, _, T:CPPTypeExpr) => E
          requires notBool isDependentInScope(T)
     rule xd(E::Expr, _, _, T:CPPTypeExpr) => E
          requires notBool isDependentInScope(T)
     rule prd(E::Expr, _, _, T:CPPTypeExpr) => E
          requires notBool isDependentInScope(T)

endmodule
