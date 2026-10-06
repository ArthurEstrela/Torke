package br.com.torke.bootstrap;
import com.tngtech.archunit.core.importer.ClassFileImporter;
import org.junit.jupiter.api.Test;
import static com.tngtech.archunit.lang.syntax.ArchRuleDefinition.noClasses;
class HexagonalArchitectureTest {
    private final com.tngtech.archunit.core.domain.JavaClasses classes=new ClassFileImporter().importPackages("br.com.torke");
    @Test void domainMustNotDependOnFrameworks(){noClasses().that().resideInAPackage("..domain..").should().dependOnClassesThat().resideInAnyPackage("org.springframework..","jakarta.persistence..","br.com.torke.adapter..","br.com.torke.bootstrap..").check(classes);}
    @Test void applicationMustNotDependOnAdapters(){noClasses().that().resideInAPackage("..application..").should().dependOnClassesThat().resideInAnyPackage("br.com.torke.adapter..","br.com.torke.bootstrap..","org.springframework..").check(classes);}
}
