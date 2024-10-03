-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema inventarios
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema inventarios
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `inventarios` DEFAULT CHARACTER SET utf8mb4 ;
USE `inventarios` ;

-- -----------------------------------------------------
-- Table `inventarios`.`almacen`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `inventarios`.`almacen` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(50) NOT NULL DEFAULT '0',
  `descripcion` VARCHAR(250) NOT NULL DEFAULT '0',
  `fecha_creacion` DATETIME NOT NULL,
  `fecha_modificacion` DATETIME NOT NULL,
  `fecha_eliminacion` DATETIME NOT NULL,
  `estatus` BIT(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `inventarios`.`catalogo_movimiento_almacen`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `inventarios`.`catalogo_movimiento_almacen` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(50) NOT NULL DEFAULT '0',
  `tipo` VARCHAR(50) NOT NULL DEFAULT '0',
  `operacion` ENUM('Entrada', 'Salida') NOT NULL,
  `fecha_creacion` DATETIME NOT NULL,
  `fecha_modificacion` DATETIME NOT NULL,
  `fecha_eliminacion` DATETIME NOT NULL,
  `estatus` BIT(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `inventarios`.`orden_traslado_almacen`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `inventarios`.`orden_traslado_almacen` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT,
  `descripcion` VARCHAR(50) NOT NULL,
  `fecha_creacion` DATETIME NOT NULL,
  `fecha_modificacion` DATETIME NOT NULL,
  `fecha_eliminacion` DATETIME NOT NULL,
  `fecha_cierre` DATETIME NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `inventarios`.`producto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `inventarios`.`producto` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NULL DEFAULT NULL,
  `descripcion` VARCHAR(250) NULL DEFAULT NULL,
  `clave_producto_servicio` VARCHAR(10) NULL DEFAULT NULL,
  `fecha_creacion` DATETIME NULL DEFAULT NULL,
  `fecha_modificacion` DATETIME NULL DEFAULT NULL,
  `fecha_eliminacion` DATETIME NULL DEFAULT NULL,
  `estatus` BIT(1) NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `inventarios`.`relacion_producto_almacen`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `inventarios`.`relacion_producto_almacen` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT,
  `id_producto` BIGINT(20) NOT NULL,
  `id_almacen` BIGINT(20) NOT NULL,
  `fecha_creacion` DATETIME NOT NULL,
  `fecha_modificacion` DATETIME NOT NULL,
  `fecha_eliminacion` DATETIME NOT NULL,
  `estatus` TINYINT(4) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  INDEX `FK1_relacion_producto_almacen_id_producto` (`id_producto` ASC) VISIBLE,
  INDEX `FK2_relacion_producto_almacen_id_almacen` (`id_almacen` ASC) VISIBLE,
  CONSTRAINT `FK1_relacion_producto_almacen_id_producto`
    FOREIGN KEY (`id_producto`)
    REFERENCES `inventarios`.`producto` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FK2_relacion_producto_almacen_id_almacen`
    FOREIGN KEY (`id_almacen`)
    REFERENCES `inventarios`.`almacen` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `inventarios`.`detalle_orden_traslado`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `inventarios`.`detalle_orden_traslado` (
  `id` INT(11) NULL DEFAULT NULL,
  `id_orden_traslado_almacen` BIGINT(20) NULL DEFAULT NULL,
  `id_catalogo_movimiento_almacen` BIGINT(20) NULL DEFAULT NULL,
  `cantidad` DECIMAL(20,6) NULL DEFAULT NULL,
  `fecha_creacion` DATETIME NULL DEFAULT NULL,
  `fecha_modificacion` DATETIME NULL DEFAULT NULL,
  `fecha_eliminacion` DATETIME NULL DEFAULT NULL,
  `estatus` BIT(1) NULL DEFAULT b'0',
  `id_relacion_producto_almacen` BIGINT NULL,
  INDEX `FK1_detalle_orden_traslado_id_orden_traslado_almacen` (`id_orden_traslado_almacen` ASC) VISIBLE,
  INDEX `FK2_detalle_orden_traslado_id_catalogo_movimiento_almacen` (`id_catalogo_movimiento_almacen` ASC) VISIBLE,
  INDEX `FK2_detalle_orden_traslado_id_relacion_producto_almacen_idx` (`id_relacion_producto_almacen` ASC) VISIBLE,
  CONSTRAINT `FK1_detalle_orden_traslado_id_orden_traslado_almacen`
    FOREIGN KEY (`id_orden_traslado_almacen`)
    REFERENCES `inventarios`.`orden_traslado_almacen` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FK2_detalle_orden_traslado_id_catalogo_movimiento_almacen`
    FOREIGN KEY (`id_catalogo_movimiento_almacen`)
    REFERENCES `inventarios`.`catalogo_movimiento_almacen` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FK2_detalle_orden_traslado_id_relacion_producto_almacen`
    FOREIGN KEY (`id_relacion_producto_almacen`)
    REFERENCES `inventarios`.`relacion_producto_almacen` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `inventarios`.`kardex_producto_almacen`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `inventarios`.`kardex_producto_almacen` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT,
  `id_relacion_producto_almacen` BIGINT(20) NOT NULL,
  `id_catalogo_movimiento_almacen` BIGINT(20) NOT NULL,
  `cantidad` DECIMAL(20,6) NOT NULL DEFAULT 0.000000,
  `fecha_movimiento` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  INDEX `FK1_kardex_producto_almacen_id_relacion_producto_almacen_idx` (`id_relacion_producto_almacen` ASC) VISIBLE,
  INDEX `FK1_kardex_producto_almacen_id_relacion_producto_almacen_idx1` (`id_catalogo_movimiento_almacen` ASC) VISIBLE,
  CONSTRAINT `FK1_kardex_producto_almacen_id_relacion_producto_almacen`
    FOREIGN KEY (`id_relacion_producto_almacen`)
    REFERENCES `inventarios`.`relacion_producto_almacen` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK1_kardex_producto_almacen_id_catalogo_movimiento_almacen`
    FOREIGN KEY (`id_catalogo_movimiento_almacen`)
    REFERENCES `inventarios`.`catalogo_movimiento_almacen` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
